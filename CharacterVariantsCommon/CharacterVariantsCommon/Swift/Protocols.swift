//
//  Protocols.swift
//
//  Created by Jared Bourgeois on 8/10/19.
//  Copyright © 2019 jaredmbourgeois. All rights reserved.
//

import UIKit

public protocol Colorable {
    func update(mainColor: UIColor?, textColor: UIColor?) -> Void
}

public protocol Dismissable {
    var dismissesOnTouch: Bool? { get set }
    var dismissingSplitViewController: UISplitViewController? { get set }
    func dismiss() -> Void
}

public protocol Sizable {
    static func number(from size: Format.Size) -> NSNumber
    static func size(from number: NSNumber) -> Format.Size
}
