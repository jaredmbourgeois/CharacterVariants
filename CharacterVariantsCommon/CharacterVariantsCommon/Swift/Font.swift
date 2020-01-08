//
//  Font.swift
//
//  Created by Jared Bourgeois on 12/18/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public enum Font {
    public static func font(name: Font.Name, size: Format.Size, style: Font.Style, modifier: Font.Modifier) -> UIFont {
        switch (name) {
        case .arial:
            return arial(size: size, style: style, modifier: modifier)
        case .avenir:
            return avenir(size: size, style: style, modifier: modifier)
        case .courierNew:
            return courierNew(size: size, style: style, modifier: modifier)
        case .helveticaNeue:
            return helveticaNeue(size: size, style: style, modifier: modifier)
        case .trebuchet:
            return trebuchet(size: size, style: style, modifier: modifier)
        }
    }
    
    public enum Name: String {
        case arial = "Arial"
        case avenir = "Avenir"
        case courierNew = "CourierNewPS"
        case helveticaNeue = "HelveticaNeue"
        case trebuchet = "Trebuchet"
    }
    
    public enum Style: String {
        case thin = "Thin"
        case ultraLight = "UltraLight"
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case semiBold = "SemiBold"
        case bold = "Bold"
    }
    
    public enum Modifier: String {
        case none = ""
        case italic = "Italic"
    }
    
    public enum Size: CGFloat, Sizable {
        case zero = 0
        case extraSmall = 10
        case small = 12
        case mediumSmall = 16
        case medium = 20
        case mediumLarge = 24
        case large = 32
        case extraLarge = 36
        case title = 42
        
        static public func size(from number: NSNumber) -> Format.Size {
            switch (number.intValue) {
            case Size.zero.rawValue.toInt():
                return Format.Size.zero
            case Size.extraSmall.rawValue.toInt():
                return Format.Size.extraSmall
            case Size.small.rawValue.toInt():
                return Format.Size.small
            case Size.mediumSmall.rawValue.toInt():
                return Format.Size.mediumSmall
            case Size.medium.rawValue.toInt():
                return Format.Size.medium
            case Size.mediumLarge.rawValue.toInt():
                return Format.Size.mediumLarge
            case Size.large.rawValue.toInt():
                return Format.Size.large
            case Size.extraLarge.rawValue.toInt():
                return Format.Size.extraLarge
            case Size.title.rawValue.toInt():
                return Format.Size.title
            default:
                return Format.Size.zero
            }
        }
        
        static public func number(from size: Format.Size) -> NSNumber {
            switch (size) {
            case Format.Size.zero:
                return CGFloat.zero.toNSNumber()
            case Format.Size.extraSmall:
                return Font.Size.extraSmall.rawValue.toNSNumber()
            case Format.Size.small:
                return Font.Size.small.rawValue.toNSNumber()
            case Format.Size.mediumSmall:
                return Font.Size.mediumSmall.rawValue.toNSNumber()
            case Format.Size.medium:
                return Font.Size.medium.rawValue.toNSNumber()
            case Format.Size.mediumLarge:
                return Font.Size.mediumLarge.rawValue.toNSNumber()
            case Format.Size.large:
                return Font.Size.large.rawValue.toNSNumber()
            case Format.Size.extraLarge:
                return Font.Size.extraLarge.rawValue.toNSNumber()
            case Format.Size.title:
                return Font.Size.title.rawValue.toNSNumber()
            }
        }
    }
    
    private static func arial(size: Format.Size, style: Font.Style, modifier: Font.Modifier) -> UIFont {
        let fontSize: CGFloat = Font.Size.number(from: size).cgFloatValue
        let fontName: String
        switch style {
        case .thin, .ultraLight, .light, .regular, .medium:
            fontName = modifier == Font.Modifier.italic ?
                Name.arial.rawValue + "-" + Font.Modifier.italic.rawValue + "MT" :
                Name.arial.rawValue + "MT"
            break
        case .semiBold, .bold:
            fontName = Name.arial.rawValue + "-" + Font.Style.bold.rawValue + modifier.rawValue + "MT"
            break
        }
        return UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    private static func avenir(size: Format.Size, style: Font.Style, modifier: Font.Modifier) -> UIFont {
        let fontSize: CGFloat = Font.Size.number(from: size).cgFloatValue
        var fontName: String
        switch style {
        case .thin, .ultraLight, .light:
            fontName = Font.Name.avenir.rawValue + "-" + Font.Style.light.rawValue
            break
        case .regular:
            fontName = Font.Name.avenir.rawValue + "-" + "Book"
            break
        case .medium:
            fontName = Font.Name.avenir.rawValue + "-" + Font.Style.medium.rawValue
            break
        case .semiBold:
            fontName = Font.Name.avenir.rawValue + "-" + "Heavy"
            break
        case .bold:
            fontName = Font.Name.avenir.rawValue + "-" + "Black"
            break
        }
        fontName = modifier == Font.Modifier.italic ? fontName + "Oblique" : fontName
        return UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    private static func courierNew(size: Format.Size, style: Font.Style, modifier: Font.Modifier) -> UIFont {
        let fontSize: CGFloat = Font.Size.number(from: size).cgFloatValue
        var fontName: String = Font.Name.courierNew.rawValue
        switch style {
        case .thin, .ultraLight, .light, .regular, .medium:
            fontName = modifier == Font.Modifier.italic ?
                Name.courierNew.rawValue + "-" + Font.Modifier.italic.rawValue :
                Name.courierNew.rawValue
            break
        case .semiBold, .bold:
            fontName = modifier == Font.Modifier.italic ?
                Name.courierNew.rawValue + "-" + Font.Style.bold.rawValue + Font.Modifier.italic.rawValue :
                Name.courierNew.rawValue + "-" + Font.Style.bold.rawValue
            break
        }
        fontName = fontName + "MT"
        return UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    private static func helveticaNeue(size: Format.Size, style: Font.Style, modifier: Font.Modifier) -> UIFont {
        let fontSize: CGFloat = Font.Size.number(from: size).cgFloatValue
        var fontName: String = Font.Name.helveticaNeue.rawValue
        switch style {
        case .thin:
            fontName = modifier == Font.Modifier.italic ?
                fontName + "-" + Font.Style.thin.rawValue + Font.Modifier.italic.rawValue :
                fontName + "-" + Font.Style.thin.rawValue
            break
        case .ultraLight:
            fontName = modifier == Font.Modifier.italic ?
                fontName + "-" + Font.Style.ultraLight.rawValue + Font.Modifier.italic.rawValue :
                fontName + "-" + Font.Style.ultraLight.rawValue
            break
        case .light:
            fontName = modifier == Font.Modifier.italic ?
                fontName + "-" + Font.Style.light.rawValue + Font.Modifier.italic.rawValue :
                fontName + "-" + Font.Style.light.rawValue
            break
        case .regular:
            if (modifier == Font.Modifier.italic) {
                fontName = fontName + "-" + Font.Modifier.italic.rawValue
            }
            break
        case .medium:
            fontName = modifier == Font.Modifier.italic ?
                fontName + "-" + Font.Style.medium.rawValue + Font.Modifier.italic.rawValue :
                fontName + "-" + Font.Style.medium.rawValue
            break
        case .semiBold, .bold:
            fontName = modifier == Font.Modifier.italic ?
                fontName + "-" + Font.Style.bold.rawValue + Font.Modifier.italic.rawValue :
                fontName + "-" + Font.Style.bold.rawValue
            break
        }
        return UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    private static func trebuchet(size: Format.Size, style: Font.Style, modifier: Font.Modifier) -> UIFont {
        let fontSize: CGFloat = Font.Size.number(from: size).cgFloatValue
        let fontName: String
        switch style {
        case .thin, .ultraLight, .light, .regular, .medium:
            fontName = modifier == .italic ?
                Font.Name.trebuchet.rawValue + "MS" + "-" + Font.Modifier.italic.rawValue :
                Font.Name.trebuchet.rawValue + "MS"
            break
        case .semiBold, .bold:
            fontName = modifier == .italic ?
                Font.Name.trebuchet.rawValue + "-" + Font.Style.bold.rawValue + Font.Modifier.italic.rawValue :
                Font.Name.trebuchet.rawValue + "MS" + "-" + Font.Style.bold.rawValue
            break
        }
        return UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
