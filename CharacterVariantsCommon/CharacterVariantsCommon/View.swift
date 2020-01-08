//
//  View.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/23/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import UIKit

public enum ViewConfiguration {
    public static var fontName: Font.Name { .helveticaNeue }
    public static var insetX: CGFloat { Format.Inset.mediumLarge.rawValue }

    public enum Button {
        public static var cornerRadius: CGFloat { Format.Radius.large.rawValue }
        public static var font: UIFont { Font.font(name: fontName, size: .medium, style: .regular, modifier: .none) }
        public static var height: CGFloat { Format.Height.large.rawValue }
    }
    public enum List {
        public enum Footer {
            public static var height: CGFloat { Format.UI.Height.button.rawValue }
        }
        public enum Cell {
            public static var font: UIFont { Font.font(name: fontName, size: .large, style: .bold, modifier: .none) }
            public static var separatorLineWidth: CGFloat { Format.LineWidth.small.rawValue }
        }
        public enum Header {
            public static var font: UIFont { Font.font(name: fontName, size: .large, style: .bold, modifier: .none) }
            public static var height: CGFloat { Format.UI.Height.bar.rawValue }
            public static var insetY: CGFloat { Format.Inset.small.rawValue }
        }
        public enum Search {
            public static var font: UIFont { Font.font(name: fontName, size: .medium, style: .bold, modifier: .none) }
            public static var height: CGFloat { Format.Height.large.rawValue }
        }
        public enum Table {
            public static var cornerRadius: CGFloat { Format.Radius.extraLarge.rawValue }
        }
    }
    public enum Detail {
        public static var fontTitle: UIFont { Font.font(name: fontName, size: .title, style: .bold, modifier: .none) }
        public static var fontDescription: UIFont { Font.font(name: fontName, size: .medium, style: .bold, modifier: .none) }
        public static var insetY: CGFloat { Format.Inset.small.rawValue }
        public static var heightHeader: CGFloat { Format.UI.Height.bar.rawValue }
        public static var heightFooter: CGFloat { Format.UI.Height.bar.rawValue }
    }
}

public class ButtonContainerView: UIView {
    public lazy var deleteCharactersButton: UIButton = {
        let deleteCharactersButton = UIButton.button(
            title: "Delete Characters",
            font: ViewConfiguration.Button.font,
            textAlignment: .center,
            textColor: mainConfiguration.colorScheme.listBackgroundLight.color,
            backgroundColor: mainConfiguration.colorScheme.font.color,
            cornerRadius: ViewConfiguration.Button.cornerRadius
        )
        addSubview(deleteCharactersButton)
        NSLayoutConstraint.activate([
            deleteCharactersButton.topAnchor.constraint(equalTo: topAnchor, constant: ViewConfiguration.insetX),
            deleteCharactersButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewConfiguration.insetX),
            deleteCharactersButton.leftAnchor.constraint(equalTo: leftAnchor, constant: ViewConfiguration.insetX),
            deleteCharactersButton.rightAnchor.constraint(equalTo: centerXAnchor, constant: -0.5 * ViewConfiguration.insetX)
        ])
        return deleteCharactersButton
    }()
    public lazy var refreshCharactersButton: UIButton = {
        let refreshCharactersButton = UIButton.button(
            title: "Refresh Characters",
            font: ViewConfiguration.Button.font,
            textAlignment: .center,
            textColor: mainConfiguration.colorScheme.listBackgroundLight.color,
            backgroundColor: mainConfiguration.colorScheme.font.color,
            cornerRadius: ViewConfiguration.Button.cornerRadius
        )
        addSubview(refreshCharactersButton)
        NSLayoutConstraint.activate([
            refreshCharactersButton.topAnchor.constraint(equalTo: topAnchor, constant: ViewConfiguration.insetX),
            refreshCharactersButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewConfiguration.insetX),
            refreshCharactersButton.leftAnchor.constraint(equalTo: centerXAnchor, constant: 0.5 * ViewConfiguration.insetX),
            refreshCharactersButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -ViewConfiguration.insetX)
        ])
        return refreshCharactersButton
    }()
}

public class CharacterCell: UITableViewCell {
    public static var reuseIdentifier: String { String.init(describing: CharacterCell.self) }

    public lazy var characterLabel: UILabel = {
        let characterLabel = UILabel.label(
            font: ViewConfiguration.List.Cell.font,
            textColor: mainConfiguration.colorScheme.font.color,
            textAlignment: .left,
            numberOfLines: 0
        )
        contentView.addSubview(characterLabel)
        NSLayoutConstraint.activate([
            characterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2 * ViewConfiguration.insetX),
            characterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2*ViewConfiguration.insetX),
            characterLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: ViewConfiguration.insetX),
            characterLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -ViewConfiguration.insetX)
        ])
        return characterLabel
    }()
    
    public override func draw(_ rect: CGRect) {
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            let separatorY: CGFloat = rect.maxY - 0.5 * ViewConfiguration.List.Cell.separatorLineWidth
            context.setLineWidth(ViewConfiguration.List.Cell.separatorLineWidth)
            context.setStrokeColor(mainConfiguration.colorScheme.font.color.cgColor)
            context.move(to: CGPoint(x: rect.origin.x + 2.0 * ViewConfiguration.insetX, y: separatorY))
            context.addLine(to: CGPoint(x: rect.maxX, y: separatorY))
            context.strokePath()
        }
    }
}

public class GradientLayer: CALayer {
    public var parent: Parent = .list {
        didSet { self.setNeedsDisplay() }
    }
    public enum Parent {
        case list
        case detail
    }
    override public func draw(in context: CGContext) {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        switch parent {
        case .list:
            let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: [
                    mainConfiguration.colorScheme.listBackgroundDark.color.cgColor,
                    mainConfiguration.colorScheme.listBackgroundLight.color.cgColor,
                    mainConfiguration.colorScheme.listBackgroundDark.color.cgColor
                ] as CFArray,
                locations: [0.0, 0.5, 1.0])
            context.drawLinearGradient(gradient!, start: CGPoint(x: bounds.center.x, y: bounds.minY), end: CGPoint(x: bounds.center.x, y: bounds.maxY), options: .drawsAfterEndLocation)
            break
        case .detail:
            let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: [
                    mainConfiguration.colorScheme.detailBackgroundDark.color.cgColor,
                    mainConfiguration.colorScheme.detailBackgroundLight.color.cgColor
                ] as CFArray,
                locations: [0.0, 1.0])
            context.drawRadialGradient(gradient!, startCenter: bounds.center, startRadius: 0, endCenter: bounds.center, endRadius: 0.5 * bounds.size.max, options: .drawsAfterEndLocation)
            break
        }
    }
}

public class LogoHeaderView: UIView {
    public lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = FileSystemInterface.logoImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConfiguration.insetX),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 2.0/3.0),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: 0.0 * ViewConfiguration.List.Header.insetY),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        return imageView
    }()
    public lazy var label: UILabel = {
        let label: UILabel = UILabel.label(font: ViewConfiguration.List.Header.font, textColor: mainConfiguration.colorScheme.font.color, textAlignment: .center, numberOfLines: 0)
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo:  imageView.trailingAnchor, constant: ViewConfiguration.insetX),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConfiguration.insetX),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2)
        ])
        return label
    }()
}
