//
//  Model.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import Foundation

public enum Model {
    public enum JSON {
        public struct CharacterAPIResponse {
            public let characters: [Character]
            
            public enum CodingKey {
                public static var characters: String { "RelatedTopics" }
            }
            
            public init(from dictionary: Dictionary <String,Any>) {
                if let characterDictionaries: [Dictionary<String, Any>] = dictionary[CodingKey.characters] as? [Dictionary<String, Any>] {
                    var characters: [Character] = []
                    for characterDictionary: Dictionary<String, Any> in characterDictionaries {
                        characters.append(Character(from: characterDictionary))
                    }
                    self.characters = characters
                }
                else {
                    Configuration.printFatalError("ERROR: Model.JSON.CharacterAPIResponse.init characterDictionaries == nil, debugDescription == (\(dictionary.debugDescription))")
                }
            }
        }
        
        public struct Character {
            public let title: String
            public let description: String
            public let iconURL: String
            
            public init(from dictionary: Dictionary <String,Any>) {
                let descriptionRaw: String = dictionary[CodingKey.description] as? String ?? String.empty
                let descriptionComponents: [String] = descriptionRaw.components(separatedBy: CodingKey.separator)
                if descriptionComponents.count >= 2 {
                    self.title = descriptionComponents[0]
                    
                    var description: String = descriptionComponents[1]
                    for index: Int in 2 ..< descriptionComponents.count {
                        description += CodingKey.separator + descriptionComponents[index]
                    }
                    self.description = description
                }
                else {
                    self.title = String.empty
                    self.description = descriptionRaw
                }
                var iconURL: String = String.empty
                if let icon: Dictionary = dictionary[CodingKey.icon] as? Dictionary<String, Any> {
                    if let url: String = icon[CodingKey.url] as? String {
                        iconURL = url
                    }
                }
                self.iconURL = iconURL
            }
            
            public enum CodingKey {
                public static var description: String { "Text" }
                public static var icon: String { "Icon" }
                public static var separator: String { " - " }
                public static var url: String { "URL" }
            }
        }        
    }
}
