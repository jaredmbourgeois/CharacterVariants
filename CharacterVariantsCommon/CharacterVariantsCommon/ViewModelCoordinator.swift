//
//  ViewModelCoordinator.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import CoreData
import UIKit

public class ViewModelCoordinator: NSObject {    
    public enum Callback {
        public typealias DatabaseLoaded = CoreDataInterface.LoadPersistentStoresCompletionHandler
        public typealias FilteredCharactersChanged = () -> Void
    }
    
    private var coreDataInterface: CoreDataInterface
    private lazy var networkQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = NetworkInterface.queueName
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    private lazy var searchQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "SearchQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private var filteredCharactersChangedCallback: Callback.FilteredCharactersChanged
    
    public var characterViewModels: [ViewModel.Character]
    public var filteredCharacterViewModels: [ViewModel.Character]
    public var filterText: String {
        didSet {
            if (filterText != String.empty) {
                searchQueue.addOperation {
                    let filteredCharacters: [ViewModel.Character] = self.characterViewModels.filter({
                        $0.title.lowercased().contains(self.filterText.lowercased()) ||
                        $0.description.lowercased().contains(self.filterText.lowercased())
                    })
                    OperationQueue.main.addOperation {
                        self.filteredCharacterViewModels = filteredCharacters
                        self.filteredCharactersChanged()
                    }
                }
            }
            else {
                self.filteredCharacterViewModels = self.characterViewModels
                self.filteredCharactersChanged()
            }
        }
    }

    
    public init(databaseLoadedCallback: @escaping Callback.DatabaseLoaded, filteredCharactersChangedCallback: @escaping Callback.FilteredCharactersChanged) {
        self.filteredCharactersChangedCallback = filteredCharactersChangedCallback
        self.filteredCharacterViewModels = []
        self.characterViewModels = []
        self.coreDataInterface = CoreDataInterface(
            databaseLoadedCallback: databaseLoadedCallback
        )
        self.filterText = String.empty
        super.init()
    }
        
    public func filteredCharactersChanged() -> Void {
        OperationQueue.main.addOperation {
            self.filteredCharactersChangedCallback()
        }
    }
    
    public struct DeleteCharactersResponse {
        let operationQueue: OperationQueue
        let handler: (ViewModelCoordinator) -> Void
    }
    public func deleteCharacters(with deleteCharactersResponse: DeleteCharactersResponse?) -> Void {
        coreDataInterface.persistentContainer.performBackgroundTask({(managedObjectContext: NSManagedObjectContext) -> Void in
            CoreDataInterface.Query.Character.all(in: managedObjectContext).forEach({
                CoreDataInterface.Command.Character.delete($0)
            })
            if let deleteCharactersResponse: DeleteCharactersResponse = deleteCharactersResponse {
                deleteCharactersResponse.operationQueue.addOperation {
                    deleteCharactersResponse.handler(self)
                }
            }
        })
    }
    
    public func downloadCharacterImage(url: String, characterTitle: String, index: Int) -> Void {
        networkQueue.addOperation {
            let downloadCharacterImageRequest: NetworkInterface.Request.DownloadCharacterImage = NetworkInterface.Request.DownloadCharacterImage(
                url: url,
                characterTitle: characterTitle,
                index: index,
                callback: self.downloadCharacterImageCallback(response:),
                callbackQueue: self.networkQueue
            )
            NetworkInterface.downloadCharacterImage(downloadCharacterImageRequest)
        }
    }
    
    public func downloadCharacterImageCallback(response: NetworkInterface.Response.DownloadCharacterImage) -> Void {
        if let imageData: Data = response.imageData {
            self.coreDataInterface.persistentContainer.performBackgroundTask({(managedObjectContext: NSManagedObjectContext) -> Void in
                if let characterWithTitle: CVCharacter = CoreDataInterface.Query.Character.titled(response.characterTitle, in: managedObjectContext) {
                    CoreDataInterface.Command.Character.update(characterWithTitle, imageData: imageData)
                    OperationQueue.main.addOperation {
                        if (self.characterViewModels.count > response.index) {
                            let characterViewModel: ViewModel.Character = self.characterViewModels[response.index]
                            characterViewModel.image = UIImage(data: imageData) ?? nil
                        }
                    }
                }
            })
        }
    }
    
    public func downloadCharacters() -> Void {
        networkQueue.addOperation {
            let downloadCharactersRequest: NetworkInterface.Request.DownloadCharacters = NetworkInterface.Request.DownloadCharacters(
                url: mainConfiguration.urlList.api,
                callback: self.downloadCharactersCallback(response:),
                callbackQueue: self.networkQueue
            )
            NetworkInterface.downloadCharacters(downloadCharactersRequest)
        }
    }
    
    public func downloadCharactersCallback(response: NetworkInterface.Response.DownloadCharacters) -> Void {
        if let characterData: Data = response.characterData {
            do {
                if let characterDataDictionary: Dictionary = try JSONSerialization.jsonObject(with: characterData, options: .mutableLeaves) as? Dictionary<String,Any> {
                    let characterAPIResponse: Model.JSON.CharacterAPIResponse = Model.JSON.CharacterAPIResponse(from: characterDataDictionary)
                    coreDataInterface.persistentContainer.performBackgroundTask({(managedObjectContext: NSManagedObjectContext) -> Void in
                        characterAPIResponse.characters.forEach({ CoreDataInterface.Command.Character.insert(from: $0, into: managedObjectContext) })
                        OperationQueue.main.addOperation {
                            self.refreshCharacterViewModels()
                        }
                    })
                }
            } catch {
                Configuration.printFatalError("ERROR: ViewModelCoordinator.downloadCharactersResponse JSONSerialization.jsonObject failed with data=\(characterData.debugDescription)")
            }
        }
    }
    
    public func refreshCharacterViewModels() -> Void {
        characterViewModels = []
        let characters = CoreDataInterface.Query.Character.all(in: coreDataInterface.persistentContainer.viewContext)
        var index: Int = 0
        characters.forEach({ (character: CVCharacter) in
            let viewModel: ViewModel.Character = ViewModel.Character(from: character)
            characterViewModels.append(viewModel)
            if (character.characterIconImage == nil) {
                let indexNetwork: Int = index
                networkQueue.addOperation {
                    NetworkInterface.downloadCharacterImage(
                        NetworkInterface.Request.DownloadCharacterImage(
                            url: character.characterIconURL ?? String.empty,
                            characterTitle: character.characterTitle ?? String.empty,
                            index: indexNetwork,
                            callback: self.downloadCharacterImageCallback(response:),
                            callbackQueue: self.networkQueue
                        )
                    )
                }
            }
            index += 1
        })
        filterText = String.empty
    }
}
