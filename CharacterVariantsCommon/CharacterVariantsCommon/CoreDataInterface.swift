//
//  CoreDataInterface.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import CoreData
import UIKit

public class CoreDataInterface {
    public typealias LoadPersistentStoresCompletionHandler = () -> Void

    public let persistentContainer: NSPersistentContainer
    public static var persistentContainerName: String { "CoreDataPersistentContainer" }
    
    private static func managedObjectModel(named managedObjectModelName: String) -> NSManagedObjectModel {
        let bundle: Bundle = Bundle(for: CoreDataInterface.self)
        if let modelURL: URL = bundle.url(forResource: managedObjectModelName, withExtension: "momd") {
            do {
                let modelData: Data = try Data(contentsOf: modelURL)
                let model: NSManagedObjectModel = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSManagedObjectModel.self, from: modelData)!
                return model
            } catch {
                fatalError()
            }
        }
        fatalError()
    }
    
    public init(databaseLoadedCallback: @escaping LoadPersistentStoresCompletionHandler) {
        persistentContainer = NSPersistentContainer(name: CoreDataInterface.persistentContainerName, managedObjectModel: CoreDataInterface.managedObjectModel(named: mainConfiguration.fileSystem.managedObjectModelName))
        if let databaseURL: URL = URL(string: "\(FileSystemInterface.databaseDirectory)\(mainConfiguration.fileSystem.databaseName)") {
            let persistentStoreDescription: NSPersistentStoreDescription = NSPersistentStoreDescription(url: databaseURL)
            persistentStoreDescription.type = NSSQLiteStoreType
            persistentStoreDescription.shouldAddStoreAsynchronously = true
            persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
            persistentContainer.loadPersistentStores(completionHandler: {(persistentStoreDescription: NSPersistentStoreDescription, error: Error?) -> Void in
                if let error = error { Configuration.printFatalError("ERROR: CoreDataInterface.init persistentContainer.loadPersistentStores() failed with error:\(error)") }
                self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
                databaseLoadedCallback()
            })
        }
        else {
            fatalError()
        }
    }
    
    public enum Command {
        public enum Character {
            public static func delete(_ character: CVCharacter) -> Void {
                CVCharacter.delete(character)
            }
            public static func insert(from jsonCharacter: Model.JSON.Character, into managedObjectContext: NSManagedObjectContext) -> Void {
                if (jsonCharacter.title != String.empty && jsonCharacter.description != String.empty) {
                    if let characterWithTitle: CVCharacter = Query.Character.titled(jsonCharacter.title, in: managedObjectContext) {
                        characterWithTitle.update(from: jsonCharacter)
                    }
                    else {
                        CVCharacter.insert(from: jsonCharacter, in: managedObjectContext)
                    }
                }
            }
            public static func update(_ character: CVCharacter, imageData: Data) -> Void {
                character.update(characterIconImage: imageData)
            }
        }
    }
    
    public enum Query {
        public enum Character {
            public static func all(in managedObjectContext: NSManagedObjectContext) -> [CVCharacter] {
                let request: NSFetchRequest = CVCharacter.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: CVCharacter.PropertyKey.characterTitle, ascending: true)]
                do {
                    let result: [CVCharacter] = try managedObjectContext.fetch(request)
                    return result.count > 0 ? result : []
                } catch {
                    return []
                }
            }
            public static func containing(_ text: String, in managedObjectContext: NSManagedObjectContext) -> [CVCharacter] {
                let request: NSFetchRequest = CVCharacter.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: CVCharacter.PropertyKey.characterTitle, ascending: true)]
                request.predicate = NSPredicate.init(format:"%@ LIKE %@ OR %@ LIKE %@", CVCharacter.PropertyKey.characterTitle, text, CVCharacter.PropertyKey.characterDescription, text)
                do {
                    let result: [CVCharacter] = try managedObjectContext.fetch(request)
                    return result.count > 0 ? result : []
                } catch {
                    return []
                }
            }
            public static func titled(_ title: String, in managedObjectContext: NSManagedObjectContext) -> CVCharacter? {
                let characters = all(in: managedObjectContext)
                var characterWithTitle: CVCharacter? = nil
                characters.forEach({ if ($0.characterTitle == title){ characterWithTitle = $0} })
                return characterWithTitle
//                let request: NSFetchRequest = CVCharacter.fetchRequest()
//                request.sortDescriptors = [NSSortDescriptor(key: CVCharacter.PropertyKey.characterTitle, ascending: true)]
//                request.predicate = NSPredicate.init(format:"characterTitle==%@", CVCharacter.PropertyKey.characterTitle, title)
//                do {
//                    let result: [CVCharacter] = try managedObjectContext.fetch(request)
//                    return result.count > 0 ? result[0] : nil
//                } catch {
//                    return nil
//                }
            }
        }
    }
}
