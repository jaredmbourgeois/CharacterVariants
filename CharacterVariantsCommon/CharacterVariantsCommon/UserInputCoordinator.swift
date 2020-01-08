//
//  UserInputCoordinator.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 1/7/20.
//  Copyright © 2020 Jared Bourgeois. All rights reserved.
//

import UIKit

public class UserInputCoordinator {
    public enum RefreshCharacters {
        public static func refreshCharacters(with viewModelCoordinator: ViewModelCoordinator) -> Void {
            viewModelCoordinator.deleteCharacters(with: ViewModelCoordinator.DeleteCharactersResponse(operationQueue: OperationQueue.main, handler: refreshCharactersDeleteCharactersHandler(viewModelCoordinator:)))
        }
        private static func refreshCharactersDeleteCharactersHandler(viewModelCoordinator: ViewModelCoordinator) -> Void {
            viewModelCoordinator.downloadCharacters()
        }
    }
    
    public enum DeleteCharacters {
        public static func deleteCharacters(with viewModelCoordinator: ViewModelCoordinator) -> Void {
            viewModelCoordinator.deleteCharacters(with: ViewModelCoordinator.DeleteCharactersResponse(operationQueue: OperationQueue.main, handler: deleteCharactersHandler(viewModelCoordinator:)))
        }
        public static func deleteCharactersHandler(viewModelCoordinator: ViewModelCoordinator) -> Void {
            viewModelCoordinator.refreshCharacterViewModels()
        }
    }
}
