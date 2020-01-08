//
//  Configuration.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public let mainConfiguration: Configuration = {
    return Configuration.configuration()
}()

public struct Configuration {
    public let animateLoadingImage: Bool
    public let colorScheme: ColorScheme
    public let urlList: URLList
    public let fileSystem: FileSystem
    
    public static func configuration() -> Configuration {
        return Configuration(infoPlistPath: Bundle.main.path(forResource: "Info", ofType: "plist") ?? String.empty)
    }
    
    public struct ColorScheme {
        let detailBackgroundDark: Color
        let detailBackgroundLight: Color
        let font: Color
        let listBackgroundDark: Color
        let listBackgroundLight: Color
    }
    
    public struct FileSystem {
        let databaseName: String
        let logoImageName: String
        let managedObjectModelName: String
        
        public init(from dictionary: NSDictionary) {
            databaseName = dictionary.value(forKey: CodingKey.databaseName.rawValue) as! String
            logoImageName = dictionary.value(forKey: CodingKey.logoImageName.rawValue) as! String
            managedObjectModelName = dictionary.value(forKey: CodingKey.managedObjectModelName.rawValue) as! String
        }
        
        public enum CodingKey: String {
            case dictionary = "FileSystem"
            case databaseName = "databaseName"
            case logoImageName = "logoImageName"
            case managedObjectModelName = "managedObjectModelName"
        }
    }
    
    public struct URLList {
        let api: String
        let loadingImage: String
        let logoImage: String
    }
    
    private enum Key {
        static var root: String { "CharacterVariantsConfiguration" }
        static var animateLoadingImage: String { "AnimateLoadingImage" }
        static var colorRoot: String { "ColorSRGB255" }
        static var colorDetailBackgroundDark: String { "detailBackgroundDark"}
        static var colorDetailBackgroundLight: String { "detailBackgroundLight"}
        static var colorFont: String { "font"}
        static var colorListBackgroundDark: String { "listBackgroundDark"}
        static var colorListBackgroundLight: String { "listBackgroundLight"}
        static var urlRoot: String { "URL" }
        static var urlAPI: String { "api" }
        static var urlLoadingImage: String { "loadingImage" }
        static var urlLogoImage: String { "logoImage" }
    }
    
    public init(infoPlistPath: String) {
        if let plistDictionary: NSDictionary = NSDictionary(contentsOfFile: infoPlistPath) {
            if let configuration: NSDictionary = plistDictionary.object(forKey: Key.root) as? NSDictionary {
                if let animateLoadingImage: String = configuration.object(forKey: Key.animateLoadingImage) as? String {
                    self.animateLoadingImage = Int(animateLoadingImage) ?? Int.zero > 0 ? true : false
                }
                else {
                    Configuration.printFatalError(Configuration.initError("animateLoadingImage == nil @ \(Key.animateLoadingImage)"))
                }
                
                
                let detailBackgroundDark: Color
                let detailBackgroundLight: Color
                let font: Color
                let listBackgroundDark: Color
                let listBackgroundLight: Color
                if let color: NSDictionary = configuration.object(forKey: Key.colorRoot) as? NSDictionary {
                    if let colorDetailBackgroundDarkValue: NSDictionary = color.object(forKey: Key.colorDetailBackgroundDark) as? NSDictionary {
                        detailBackgroundDark = Color.init(from: colorDetailBackgroundDarkValue)
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("colorDetailBackgroundDark == nil @ \(Key.colorDetailBackgroundDark)"))
                    }
                    if let colorDetailBackgroundLightValue: NSDictionary = color.object(forKey: Key.colorDetailBackgroundLight) as? NSDictionary {
                        detailBackgroundLight = Color.init(from: colorDetailBackgroundLightValue)
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("colorDetailBackgroundLight == nil @ \(Key.colorDetailBackgroundLight)"))
                    }
                    if let colorFontValue: NSDictionary = color.object(forKey: Key.colorFont) as? NSDictionary {
                        font = Color.init(from: colorFontValue)
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("colorFont == nil @ \(Key.colorFont)"))
                    }
                    if let colorListBackgroundDarkValue: NSDictionary = color.object(forKey: Key.colorListBackgroundDark) as? NSDictionary {
                        listBackgroundDark = Color.init(from: colorListBackgroundDarkValue)
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("colorListBackgroundDark == nil @ \(Key.colorListBackgroundDark)"))
                    }
                    if let colorListBackgroundLightValue: NSDictionary = color.object(forKey: Key.colorListBackgroundLight) as? NSDictionary {
                        listBackgroundLight = Color.init(from: colorListBackgroundLightValue)
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("colorListBackgroundLight == nil @ \(Key.colorListBackgroundLight)"))
                    }
                    self.colorScheme = ColorScheme.init(detailBackgroundDark: detailBackgroundDark, detailBackgroundLight: detailBackgroundLight, font: font, listBackgroundDark: listBackgroundDark, listBackgroundLight: listBackgroundLight)
                }
                else {
                    Configuration.printFatalError(Configuration.initError("color == nil @ \(Key.colorRoot)"))
                }
                
                if let fileSystemDictionary: NSDictionary = configuration.object(forKey: FileSystem.CodingKey.dictionary.rawValue) as? NSDictionary {
                    self.fileSystem = FileSystem(from: fileSystemDictionary)
                }
                else {
                    Configuration.printFatalError(Configuration.initError("fileSystem == nil @ \(FileSystem.CodingKey.dictionary.rawValue)"))
                }
                
                let urlAPI: String
                let urlLoadingImage: String
                let urlLogoImage: String
                if let url: NSDictionary = configuration.object(forKey: Key.urlRoot) as? NSDictionary {
                    if let urlAPIValue: String = url.object(forKey: Key.urlAPI) as? String {
                        urlAPI = urlAPIValue
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("urlAPI == nil @ \(Key.urlAPI)"))
                    }
                    if let urlLoadingImageValue: String = url.object(forKey: Key.urlLoadingImage) as? String {
                        urlLoadingImage = urlLoadingImageValue
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("urlLoadingImage == nil @ \(Key.urlLoadingImage)"))
                    }
                    if let urlLogoImageValue: String = url.object(forKey: Key.urlLogoImage) as? String {
                        urlLogoImage = urlLogoImageValue
                    }
                    else {
                        Configuration.printFatalError(Configuration.initError("urlLogoImage == nil @ \(Key.urlLogoImage)"))
                    }
                    self.urlList = URLList(api: urlAPI, loadingImage: urlLoadingImage, logoImage: urlLogoImage)
                }
                else {
                    Configuration.printFatalError(Configuration.initError("url == nil @ \(Key.urlRoot)"))
                }
            }
            else {
                Configuration.printFatalError(Configuration.initError("configuration == nil @ \(Key.root)"))
            }
        } else {
            Configuration.printFatalError(Configuration.initError("plistDictionary == nil @ \(infoPlistPath)"))
        }
    }
    
    private static func initError(_ description: String?) -> String { return "ERROR: Configuration.init \(description ?? String.empty)" }
    
    public static func printFatalError(_ description: String) -> Never {
        print(description)
        fatalError()
    }
    
    public struct Color {
        public let red: UInt8
        public let green: UInt8
        public let blue: UInt8
        public var color: UIColor { UIColor(red: CGFloat(red.toCGFloat()/CGFloat(255.0)), green: CGFloat(green.toCGFloat()/CGFloat(255.0)), blue: CGFloat(blue.toCGFloat()/CGFloat(255.0)), alpha: 1) }
        
        public init(from dictionary: NSDictionary) {
            if let redValue: String = dictionary.value(forKey: CodingKey.red.rawValue) as? String {
                red = UInt8(redValue) ?? UInt8.zero
            }
            else {
                Configuration.printFatalError("ERROR: Configuration.Color redValue == nil forKey:\(CodingKey.red.rawValue)")
            }
            if let greenValue: String = dictionary.value(forKey: CodingKey.green.rawValue) as? String {
                green = UInt8(greenValue) ?? UInt8.zero
            }
            else {
                Configuration.printFatalError("ERROR: Configuration.Color greenValue == nil forKey:\(CodingKey.green.rawValue)")
            }
            if let blueValue: String = dictionary.value(forKey: CodingKey.blue.rawValue) as? String {
                blue = UInt8(blueValue) ?? UInt8.zero
            }
            else {
                Configuration.printFatalError("ERROR: Configuration.Color blueValue == nil forKey:\(CodingKey.blue.rawValue)")
            }
        }
        
        public enum CodingKey: String {
            case red = "red"
            case green = "green"
            case blue = "blue"
        }
    }
}
