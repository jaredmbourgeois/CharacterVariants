//
//  Extensions.swift
//  Jared Bourgeois
//
//  Created by  Jared on 12/16/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit
import CoreData 
import CoreGraphics

extension CALayer {
    public func shadow(_ description: Format.ShadowDescription) -> Void {
        CALayer.shadow(self, cornerRadius: description.cornerRadius, color: description.shadowColor, offset: description.shadowOffset, opacity: description.shadowOpacity)
    }
    public static func shadow(_ layer: CALayer, description: Format.ShadowDescription) -> Void {
        CALayer.shadow(layer, cornerRadius: description.cornerRadius, color: description.shadowColor, offset: description.shadowOffset, opacity: description.shadowOpacity)
    }
    public func shadow() -> Void {
        CALayer.shadow(self, cornerRadius: nil, color: nil, offset: nil, opacity: nil)
    }
    public func shadow(cornerRadius: CGFloat?, color: CGColor?, offset: CGSize?, opacity: Float?) -> Void {
        CALayer.shadow(self, cornerRadius: cornerRadius, color: color, offset: offset, opacity: opacity)
    }
    public static func shadow(_ layer: CALayer) -> Void {
        CALayer.shadow(layer, cornerRadius: nil, color: nil, offset: nil, opacity: nil)
    }
    public static func shadow(_ layer: CALayer, cornerRadius: CGFloat?, color: CGColor?, offset: CGSize?, opacity: Float?) -> Void {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius ?? 6
        layer.shadowColor = color ?? UIColor.StackOverflow.black.cgColor
        layer.shadowOffset = offset ?? CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = opacity ?? Float(1.0/3.0)
    }
}


extension CGFloat {
    public static var zero: CGFloat { CGFloat(0) }
    public func toDouble() -> Double { Double(self) }
    public func toInt() -> Int { Int(self) }
    public func toFloat() -> Float { Float(self) }
    public func toNSNumber() -> NSNumber { self.toDouble() as NSNumber }
    public func toString() -> String { "\(self)" }

    public func interpolate(_ value: CGFloat) -> CGFloat {
        return CGFloat.interpolate(self, value)
    }
    
    public static func interpolate(_ firstValue: CGFloat, _ secondValue: CGFloat) -> CGFloat {
        return 0.5 * (firstValue + secondValue)
    }
    
    public func toString(decimals: Int) -> String {
        return CGFloat.toString(value: self, decimals: decimals)
    }
    
    public static func toString(value: CGFloat, decimals: Int) -> String {
        let formatter: NumberFormatter = NumberFormatter.init()
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: value.toNSNumber()) ?? value.description
    }
}


extension CGPath {
    public static func rounded(rect: CGRect, radius: CGFloat, lineWidth: CGFloat) -> CGPath {
        return rounded(rect: rect, cornerRadius: radius, lineWidth: lineWidth, position: .isolated)
    }
    
    public static func rounded(rect: CGRect, cornerRadius: CGFloat, lineWidth: CGFloat, position: Format.Position) -> CGPath {
        let mutablePath: CGMutablePath = CGMutablePath.init()
        let margin: CGFloat = 0.5*lineWidth
        let topLeft: CGPoint = CGPoint.init(x: rect.minX + margin, y: rect.minY + margin)
        let topRight: CGPoint = CGPoint.init(x: rect.maxX - margin, y: rect.minY + margin)
        let bottomLeft: CGPoint = CGPoint.init(x: rect.minX + margin, y: rect.maxY - margin)
        let bottomRight: CGPoint = CGPoint.init(x: rect.maxX - margin, y: rect.maxY - margin)
        let radius: CGFloat
        
        switch position {
        case .top:
            radius = cornerRadius
            mutablePath.move(to: bottomLeft)
            mutablePath.addLine(to: CGPoint.init(x: topLeft.x, y: topLeft.y + radius))
            mutablePath.addRelativeArc(center: CGPoint.init(x: topLeft.x + radius, y: topLeft.y + radius), radius: radius, startAngle: .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: topRight.x - radius, y: topRight.y + radius), radius: radius, startAngle: (3.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addLine(to: bottomRight)
            mutablePath.addLine(to: bottomLeft)
            break
            
        case .middle:
            radius = 0
            mutablePath.addRelativeArc(center: CGPoint.init(x: topLeft.x + radius, y: topLeft.y + radius), radius: radius, startAngle: .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: topRight.x - radius, y: topRight.y + radius), radius: radius, startAngle: (3.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomRight.x - radius, y: bottomRight.y - radius), radius: radius, startAngle: 0, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomLeft.x + radius, y: bottomLeft.y - radius), radius: radius, startAngle: (1.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addLine(to: CGPoint.init(x: topLeft.x, y: topLeft.y + radius))
            break
            
        case .bottom:
            radius = cornerRadius
            mutablePath.move(to: topLeft)
            mutablePath.addLine(to: topRight)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomRight.x - radius, y: bottomRight.y - radius), radius: radius, startAngle: 0, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomLeft.x + radius, y: bottomLeft.y - radius), radius: radius, startAngle: (1.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addLine(to: topLeft)
            break
            
        case .left:
            radius = cornerRadius
            mutablePath.move(to: topRight)
            mutablePath.addLine(to: bottomRight)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomLeft.x + radius, y: bottomLeft.y - radius), radius: radius, startAngle: (1.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: topLeft.x + radius, y: topLeft.y + radius), radius: radius, startAngle: .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addLine(to: topRight)
            break
            
        case .right:
            radius = cornerRadius
            mutablePath.move(to: topLeft)
            mutablePath.addLine(to: bottomLeft)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomRight.x - radius, y: bottomRight.y - radius), radius: radius, startAngle: (1.0/2.0) * .pi, delta: -(1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: topRight.x - radius, y: topRight.y + radius), radius: radius, startAngle: 0, delta: -(1.0/2.0) * .pi)
            mutablePath.addLine(to: topLeft)
            break
            
        case .isolated:
            radius = cornerRadius
            mutablePath.addRelativeArc(center: CGPoint.init(x: topLeft.x + radius, y: topLeft.y + radius), radius: radius, startAngle: .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: topRight.x - radius, y: topRight.y + radius), radius: radius, startAngle: (3.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomRight.x - radius, y: bottomRight.y - radius), radius: radius, startAngle: 0, delta: (1.0/2.0) * .pi)
            mutablePath.addRelativeArc(center: CGPoint.init(x: bottomLeft.x + radius, y: bottomLeft.y - radius), radius: radius, startAngle: (1.0/2.0) * .pi, delta: (1.0/2.0) * .pi)
            mutablePath.addLine(to: CGPoint.init(x: topLeft.x, y: topLeft.y + radius))
            break
        }
        return mutablePath.copy()!
    }
    
    public static func checkmark(rect: CGRect) -> CGPath {
        let x: (left: CGFloat, middle: CGFloat, right: CGFloat) = (left: (4.5/32.0), middle: (12.5/32.0), right: (26.0/32.0))
        let y: (top: CGFloat, middle: CGFloat, bottom: CGFloat) = (top: (7.0/32.0), middle: (15.5/32.0), bottom: (23.0/32.0))

        let mutablePath: CGMutablePath = CGMutablePath.init()
        mutablePath.move(to: CGPoint.init(x: rect.origin.x + x.left * rect.size.width, y: rect.origin.y + y.middle * rect.size.height))
        mutablePath.addLine(to: CGPoint.init(x: rect.origin.x + x.middle * rect.size.width, y: rect.origin.y + y.bottom * rect.size.height))
        mutablePath.addLine(to: CGPoint.init(x: rect.origin.x + x.right * rect.size.width, y: rect.origin.y + y.top * rect.size.height))
        return mutablePath.copy()!
    }
}


extension CGRect {
    public var center: CGPoint { CGPoint.init(x: self.origin.x + 0.5 * self.size.width, y: self.origin.y + 0.5 * self.size.height) }
}


extension CGSize {
    public var max: CGFloat { self.width > self.height ? self.width : self.height }
    public var min: CGFloat { self.width > self.height ? self.height : self.width }
    public var aspectRatio: CGFloat { CGFloat( self.width / self.height ) }
    public var slope: CGFloat { CGFloat( self.height / self.width ) }
    public func scaleHeight(by width: CGFloat) -> CGFloat { self.height *  width / self.width }
    public func scaleWidth(by height: CGFloat) -> CGFloat { self.width * height / self.height }
}


extension Data {
    public static var empty: Data { Data() }
}


extension Date {
    public static var zero: Date { Date(timeIntervalSince1970: 0) }
    
    public static var dateFormat: String { "yyyyMMdd-HHmmss" }
    
    public static func date(string: String, format: String?, timeZoneAbbreviation: String?) -> Date {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format ?? Date.dateFormat
        if (timeZoneAbbreviation != nil) {
            dateFormatter.timeZone = TimeZone.init(identifier: timeZoneAbbreviation ?? "EST")
        }
        else {
            dateFormatter.timeZone = TimeZone.current
        }
        return dateFormatter.date(from: string) ?? Date.init()
    }
    
    public static func localDate(date: Date, format: String?) -> String {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format ?? Date.dateFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    public static func localTime(date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }

    public static func noon(date: Date?) -> Date {
        let twelveHours: TimeInterval = 12*60*60
        guard date != nil else {
            let today: Date = Date.init(timeIntervalSinceNow: 0)
            return Date.init(timeInterval: twelveHours, since: Calendar.current.startOfDay(for: today))
        }
        return Date.init(timeInterval: twelveHours, since: date!)
    }
    
    public static func noonInWeek(dateInWeek: Date, weekday: Int) -> Date {
        let twentyFourHours: TimeInterval = 24*60*60
        let components: DateComponents = Calendar.current.dateComponents([Calendar.Component.weekday, Calendar.Component.weekOfYear], from: dateInWeek)
        let noonOfDate: Date = Date.noon(date: dateInWeek)
        guard components.weekday != nil else {
            return noonOfDate
        }
        return Date.init(timeInterval: Double.init(weekday - components.weekday!) * twentyFourHours, since: noonOfDate)
    }
    
    public static func weekday(date: Date) -> Int {
        let components: DateComponents = Calendar.current.dateComponents([Calendar.Component.weekday], from: date)
        guard components.weekday != nil else {
            return 1
        }
        return components.weekday!
    }
}


extension Double {
    public static var zero: Double { Double(0) }
    public func toInt() -> Int { Int(self) }
    public func toFloat() -> Float { Float(self) }
    public func toNSNumber() -> NSNumber { self as NSNumber }
    public func toString() -> String { "\(self)" }
    
    func interpolate(_ value: Double) -> Double {
        return Double.interpolate(self, value)
    }
    
    static func interpolate(_ firstValue: Double, _ secondValue: Double) -> Double {
        return 0.5 * (firstValue + secondValue)
    }

    func toString(decimals: Int) -> String {
        return Double.toString(value: self, decimals: decimals)
    }
    
    static func toString(value: Double, decimals: Int) -> String {
        let formatter: NumberFormatter = NumberFormatter.init()
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: value as NSNumber) ?? value.description
    }
}


extension Int {
    public static var zero: Int { Int(0) }
    public func toDouble() -> Double { Double(self) }
    public func toFloat() -> Float { Float(self) }
    public func toCGFloat() -> CGFloat { CGFloat(self) }
    public func toNSNumber() -> NSNumber { self as NSNumber }
    public func toString() -> String { "\(self)" }
}


extension Int32 {
    public static var zero: Int32 { Int32(0) }
    public func toDouble() -> Double { Double(self) }
    public func toFloat() -> Float { Float(self) }
    public func toCGFloat() -> CGFloat { CGFloat(self) }
    public func toNSNumber() -> NSNumber { self as NSNumber }
    public func toString() -> String { "\(self)" }
}


extension NSAttributeDescription {
    public static func attributeDescription(isOptional: Bool, isTransient: Bool, name: String, allowsExternalBinaryDataStorage: Bool, attributeType: NSAttributeType, defaultValue: Any?, preservesValueInHistoryOnDeletion: Bool) -> NSAttributeDescription {
        let attributeDescription: NSAttributeDescription = NSAttributeDescription()
        attributeDescription.isOptional = true // NSPropertyDescription
        attributeDescription.isTransient = false
        attributeDescription.name = "characterIconImage"
        attributeDescription.allowsExternalBinaryDataStorage = false //NSAttributeDescription
        attributeDescription.attributeType = .binaryDataAttributeType
        attributeDescription.defaultValue = nil
        attributeDescription.preservesValueInHistoryOnDeletion = false
        return attributeDescription
    }
}


extension NSManagedObject {
    public func saveSucces() -> Bool {
        return saveSuccess(printError: nil)
    }
    public func saveSuccess(printError text: String?) -> Bool {
        return managedObjectContext != nil ? managedObjectContext!.saveSuccess(printError: text) : false
    }
}


extension NSManagedObjectContext {
    public func saveSucces() -> Bool {
        return saveSuccess(printError: nil)
    }
    public func saveSuccess(printError text: String?) -> Bool {
        do {
            try save()
            return true
        } catch {
            if let text = text { print(text) }
            return false
        }
    }
}

extension NSNumber {
    public var cgFloatValue: CGFloat { CGFloat(truncating: self)}
}


extension String {
    public static let empty: String = ""
    public static let zero: String = "0"
}


extension UIApplication {
    static func statusBarStyleForBackground(color: UIColor) -> UIStatusBarStyle {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let success: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return success == true ?
            (brightness >= 0.5 ?
                UIStatusBarStyle.darkContent : UIStatusBarStyle.lightContent
            ) :
            UIStatusBarStyle.default
    }
}


extension UIButton {
    public static func button() -> UIButton {
        return UIButton.button(title: nil, font: nil, textAlignment: nil, textColor: nil, backgroundColor: nil, cornerRadius: nil)
    }
    
    public static func button(title: String?, font: UIFont?, textAlignment: NSTextAlignment?, textColor: UIColor?, backgroundColor: UIColor?, cornerRadius: CGFloat?) -> UIButton {
        let btn = UIButton.init()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.showsTouchWhenHighlighted = true
        btn.clipsToBounds = false
        btn.contentMode = .scaleToFill

        btn.backgroundColor = backgroundColor ?? UIColor.red
        btn.layer.cornerRadius = cornerRadius ?? 0
        
        btn.setTitle(title ?? "", for: .normal)
        btn.setTitleColor(textColor ?? UIColor.red, for: .normal)
        btn.titleLabel?.backgroundColor = .clear
        btn.titleLabel?.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        btn.titleLabel?.textAlignment = textAlignment ?? NSTextAlignment.left
        btn.titleLabel?.textColor = textColor ?? UIColor.red
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        return btn
    }
}


extension UIColor {
    public enum StackOverflow {
        public static var black: UIColor { UIColor(red: CGFloat(25.0/255.0), green: CGFloat(26.0/255.0), blue: CGFloat(28.0/255.0), alpha: 1) }
        public static var blue: UIColor { UIColor(red: CGFloat(14.0/255.0), green: CGFloat(99.0/255.0), blue: CGFloat(194.0/255.0), alpha: 1) }
        public static var bronze: UIColor { UIColor(red: CGFloat(198.0/255.0), green: CGFloat(149.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1) }
        public static var bronzeLight: UIColor { UIColor(red: CGFloat(246.0/255.0), green: CGFloat(228.0/255.0), blue: CGFloat(213.0/255.0), alpha: 1) }
        public static var gold: UIColor { UIColor(red: CGFloat(254.0/255.0), green: CGFloat(195.0/255.0), blue: CGFloat(10.0/255.0), alpha: 1) }
        public static var goldLight: UIColor { UIColor(red: CGFloat(255.0/255.0), green: CGFloat(249.0/255.0), blue: CGFloat(224.0/255.0), alpha: 1) }
        public static var gray: UIColor { UIColor(red: CGFloat(174.0/255.0), green: CGFloat(173.0/255.0), blue: CGFloat(174.0/255.0), alpha: 1) }
        public static var green: UIColor { UIColor(red: CGFloat(80.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(106.0/255.0), alpha: 1) }
        public static var highlight: UIColor { UIColor(red: CGFloat(240.0/255.0), green: CGFloat(240.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1) }
        public static var navy: UIColor { UIColor(red: CGFloat(45.0/255.0), green: CGFloat(95.0/255.0), blue: CGFloat(139.0/255.0), alpha: 1) }
        public static var navyLight: UIColor { UIColor(red: CGFloat(218.0/255.0), green: CGFloat(231.0/255.0), blue: CGFloat(241.0/255.0), alpha: 1) }
        public static var orange: UIColor { UIColor(red: CGFloat(239.0/255.0), green: CGFloat(107.0/255.0), blue: CGFloat(28.0/255.0), alpha: 1) }
        public static var silver: UIColor { UIColor(red: CGFloat(165.0/255.0), green: CGFloat(169.0/255.0), blue: CGFloat(174.0/255.0), alpha: 1) }
        public static var silverLight: UIColor { UIColor(red: CGFloat(229.0/255.0), green: CGFloat(230.0/255.0), blue: CGFloat(231/255.0), alpha: 1) }
    }
    
    public enum Streak {
        public static var blue: UIColor { UIColor.init(red: 0.07, green: 0.61, blue: 0.85, alpha: 1) }
        public static var orange: UIColor { UIColor.init(red: 0.95, green: 0.52, blue: 0.19, alpha: 1) }
    }
    
    func contrasting(with degree: Format.Degree) -> UIColor {
        return UIColor.contrasting(color: self, degree: degree)
    }
    
    static func contrasting(color: UIColor, degree: Format.Degree) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let success: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (success == true) {
            let fraction: CGFloat = degree.rawValue
            if (brightness >= 0.5) {
                brightness -= 0.5 * fraction * brightness
            }
            else if (brightness < 0.5){
                brightness += 0.5 * fraction * brightness
            }
            return UIColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        else {
            return color
        }
    }
    
    func desaturated(with degree: Format.Degree) -> UIColor {
        UIColor.desaturated(color: self, degree: degree)
    }
    
    static func desaturated(color: UIColor, degree: Format.Degree) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let success: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (success == true) {
            let fraction: CGFloat = 1 - degree.rawValue
            return UIColor.init(hue: hue, saturation: saturation * fraction, brightness: brightness, alpha: alpha)
        }
        else {
            return color
        }
    }
    
    func transparent(degree: Format.Degree) -> UIColor {
        return UIColor.transparent(color: self, degree: degree)
    }
    
    static func transparent(color: UIColor, degree: Format.Degree) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let success: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (success == true) {
            let fraction: CGFloat = 1 - degree.rawValue
            return UIColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: fraction)
        }
        else {
            return color
        }
    }
}


extension UIFont {
    public static func font(size: Format.Size, bold: Bool) -> UIFont {
        let fontSize: CGFloat = Font.Size.number(from: size).cgFloatValue
        let fnt = UIFont.init(name: "HelveticaNeue-Medium", size: CGFloat.init(fontSize))!
        
        switch bold {
        case true:
            let descriptor: UIFontDescriptor = fnt.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)!
            return UIFont.init(descriptor: descriptor, size: CGFloat.init(size.rawValue))
            
        case false:
            return fnt
        }
    }
}


extension UIImage {
    public static var empty: UIImage { UIImage() }
}


extension UILabel {
    public static func label() -> UILabel { UILabel.label(font: nil, textColor: nil, textAlignment: nil, numberOfLines: nil) }
    
    public static func label(font: UIFont?, textColor: UIColor?, textAlignment: NSTextAlignment?, numberOfLines: Int?) -> UILabel {
        let lbl: UILabel = UILabel.init()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .clear
        lbl.isUserInteractionEnabled = false
        lbl.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        lbl.textColor = textColor ?? .red
        lbl.textAlignment = textAlignment ?? .left
        lbl.numberOfLines = numberOfLines ?? 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }
}

extension UInt8 {
    public static var zero: UInt8 { UInt8(0) }
    public func toDouble() -> Double { Double(self) }
    public func toFloat() -> Float { Float(self) }
    public func toCGFloat() -> CGFloat { CGFloat(self) }
    public func toNSNumber() -> NSNumber { self as NSNumber }
    public func toString() -> String { "\(self)" }
}

extension UISplitViewController {
    public struct DismissDetailViewController {
        public typealias HandlerCompletionHandler = () -> Void
        
        public unowned let splitViewController: UISplitViewController
        public let handlerCompletionHandler: HandlerCompletionHandler?
        public let animated: Bool
        
        public init (splitViewController: UISplitViewController, animated: Bool, handlerCompletionHandler: HandlerCompletionHandler?) {
            self.splitViewController = splitViewController
            self.handlerCompletionHandler = handlerCompletionHandler
            self.animated = animated
        }
    }
}

extension UISplitViewControllerDelegate {
    public func dismissDetailViewControllerHandler(_ dismissDetailViewController: UISplitViewController.DismissDetailViewController) -> Void {
        dismissDetailViewController.splitViewController.dismiss(animated: dismissDetailViewController.animated, completion: dismissDetailViewController.handlerCompletionHandler)
    }
}

extension UIScrollView {
    public static func indicatorStyle(matching: Bool, color: UIColor) -> UIScrollView.IndicatorStyle {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        let success: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return success == true ?
        (brightness >= 0.5 ?
            (matching == true ? .white : .black) :
            (matching == true ? .black : .white)
        ) :
        .default
    }
}


extension UIStackView {
    public func addSpacer() {
        let spacer: UIView = UIView.init()
        spacer.backgroundColor = .clear
        spacer.clipsToBounds = false
        spacer.isUserInteractionEnabled = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(spacer)
    }
}


extension UITextField {
    public func addLeftViewImage(named imageName: String) {
        let wrapperView: UIView = UIView.init(frame: self.leftViewRect(forBounds: bounds))
        wrapperView.clipsToBounds = true
        
        if let image: UIImage = UIImage.init(named: imageName) {
            let imageView: UIImageView = UIImageView.init(frame: self.leftViewRect(forBounds: bounds))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            wrapperView.addSubview(imageView)
            imageView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: wrapperView.heightAnchor, multiplier: 0.5).isActive = true
            imageView.heightAnchor.constraint(equalTo: wrapperView.heightAnchor, multiplier: 0.5).isActive = true
            self.leftView = wrapperView
            self.leftViewMode = .always
        }
    }

    public static func textField() -> UITextField { UITextField.textField(font: nil, textColor: nil, textAlignment: nil, numberOfLines: nil) }
    
    public static func textField(font: UIFont?, textColor: UIColor?, textAlignment: NSTextAlignment?, numberOfLines: Int?) -> UITextField {
        let txtField: UITextField = UITextField.init()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.backgroundColor = .clear
        txtField.isUserInteractionEnabled = false
        txtField.font = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        txtField.textColor = textColor ?? .red
        txtField.textAlignment = textAlignment ?? .left
        txtField.tintColor = textColor ?? .red
        txtField.adjustsFontSizeToFitWidth = true
        return txtField
    }
}


extension UIView {
    public func constrainToSuperview() -> Void {
        constrainToSuperview(insetX: 0, insetY: 0)
    }
    
    public func constrainToSuperview(insetX: CGFloat?, insetY: CGFloat?) -> Void {
        if let superView: UIView = superview {
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superView.topAnchor, constant: insetY ?? 0),
                bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -(insetY ?? 0)),
                leftAnchor.constraint(equalTo: superView.leftAnchor, constant: insetX ?? 0),
                leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insetX ?? 0),
                rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -(insetX ?? 0)),
                trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -(insetX ?? 0)),
                widthAnchor.constraint(equalTo: superView.widthAnchor, constant: -2 * (insetX ?? 0)),
                heightAnchor.constraint(equalTo: superView.heightAnchor, constant: -2 * (insetY ?? 0))
            ])
        }
    }
    
    public func destroySubviews() -> Void {
        let oldSubviews = self.subviews
        var subview: UIView?
        for index: Int in 0 ..< oldSubviews.count {
            subview = oldSubviews[index]
            subview?.removeFromSuperview()
            subview = nil
        }
    }
    
    public func removeSubviews() -> Void {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
        
    public static func view(frame: CGRect?, backgroundColor: UIColor?, cornerRadius: CGFloat?) -> UIView {
        let view: UIView = frame != nil ? UIView.init(frame: frame!) : UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = frame != nil ? true : false
        view.backgroundColor = backgroundColor ?? UIColor.clear
        view.layer.cornerRadius = cornerRadius ?? 0
        return view
    }
}

extension URL {
    public static let empty: URL = URL(fileURLWithPath: "")
}


extension URLResponse {
    public func isValid(data: Data?, error: Error?) -> Bool {
        return URLResponse.isValid(self, data: data, error: error)
    }
    public static func isValid(_ response: URLResponse?, data: Data?, error: Error?) -> Bool {
        return data != nil && error == nil && response != nil ? true : false
    }
}
