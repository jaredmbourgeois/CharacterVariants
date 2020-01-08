//
//  CoreDataExtensions.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import Foundation
import CoreData

extension CVCharacter {
    public static func delete(_ character: CVCharacter) -> Void {
        if let context: NSManagedObjectContext = character.managedObjectContext {
            context.delete(character)
            if !context.saveSucces() { Configuration.printFatalError("ERROR: CVCharacter.delete context.saveSuccess == false") }
        }
        else {
            Configuration.printFatalError("ERROR: CVCharacter.delete character.managedObjectContext == nil")
        }
    }
    public static func insert(from jsonCharacter: Model.JSON.Character, in context: NSManagedObjectContext) -> Void {
        let character: CVCharacter = CVCharacter(context: context)
        character.update(from: jsonCharacter)
    }
    
    public func update(from jsonCharacter: Model.JSON.Character) -> Void {
        self.characterTitle = jsonCharacter.title
        self.characterDescription = jsonCharacter.description
        self.characterIconURL = jsonCharacter.iconURL
        self.characterIconImage = nil
        if !self.saveSucces() {
            Configuration.printFatalError("ERROR: CVCharacter.update self.saveSuccess == false")
        }
    }
    
    public func update(characterIconImage: Data) -> Void {
        self.characterIconImage = characterIconImage
        if let context: NSManagedObjectContext = self.managedObjectContext {
            if !context.saveSucces() { Configuration.printFatalError("ERROR: CVCharacter.update(characterIconImage) context.saveSuccess == false, characterIconImage=\(characterIconImage.debugDescription)") }
        }
        else {
            Configuration.printFatalError("ERROR: CVCharacter.update(characterIconImage) character.managedObjectContext == nil")
        }
    }
    
    public enum PropertyKey {
        public static var characterTitle: String { "characterTitle" }
        public static var characterDescription: String { "characterDescription" }
        public static var characterIconURL: String { "characterIconURL" }
        public static var characterIconImage: String { "characterIconImage" }
    }
}
