//
//  ViewModel.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public enum ViewModel {
    public class Character {
        public typealias DidSetHandler = (ViewModel.Character) -> Void

        public var title: String
        public var description: String
        public var didSetHandlers: [DidSetHandler]
        public var image: UIImage? {
            didSet { self.didSetHandlers.forEach({ $0(self) }) }
        }

        public init(from character: CVCharacter) {
            self.title = character.characterTitle ?? String.empty
            self.description = character.characterDescription ?? String.empty
            self.image = UIImage(data: character.characterIconImage ?? Data.empty)
            self.didSetHandlers = []
        }
    }
}
