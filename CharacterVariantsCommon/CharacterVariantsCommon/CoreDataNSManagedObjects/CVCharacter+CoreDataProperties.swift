//
//  CVCharacter+CoreDataProperties.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//
//

import Foundation
import CoreData


extension CVCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CVCharacter> {
        return NSFetchRequest<CVCharacter>(entityName: "CVCharacter")
    }

    @NSManaged public var characterDescription: String?
    @NSManaged public var characterIconImage: Data?
    @NSManaged public var characterIconURL: String?
    @NSManaged public var characterTitle: String?

}
