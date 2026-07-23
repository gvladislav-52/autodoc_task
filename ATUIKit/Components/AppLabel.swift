//
//  AppLabel.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 21.07.2026.
//

import UIKit

public final class AppLabel: UILabel {
    typealias StringAttributes = [NSAttributedString.Key: Any]

    override public var text: String? {
        get {
            attributedText?.string
        }
        set {
            if let newValue {
                attributedText = NSAttributedString(
                    string: newValue,
                    attributes: defaultAttributes
                )
            } else {
                attributedText = nil
            }
        }
    }

    private(set) var defaultAttributes: StringAttributes = [:]

    public init(
        text: String? = nil,
        font: UIFont = AppFonts.body,
        color: UIColor = AppColors.palette.secondaryText,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = .zero
    ) {
        super.init(frame: .zero)
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        defaultAttributes = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: style
        ]
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
        if let text {
            attributedText = NSAttributedString(string: text, attributes: defaultAttributes)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupAttributes(
        font: UIFont? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        numberOfLines: Int? = nil,
        backgroundColor: UIColor? = nil,
        underlineStyle: NSUnderlineStyle? = nil,
        underlineColor: UIColor? = nil
    ) {
        var newAttributes: StringAttributes = [:]
        if let font { newAttributes[.font] = font }
        if let color { newAttributes[.foregroundColor] = color }
        if let alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            newAttributes[.paragraphStyle] = paragraphStyle
            self.textAlignment = alignment
        }
        if let numberOfLines { self.numberOfLines = numberOfLines }
        if let backgroundColor { newAttributes[.backgroundColor] = backgroundColor }
        if let underlineStyle { newAttributes[.underlineStyle] = underlineStyle.rawValue }
        if let underlineColor { newAttributes[.underlineColor] = underlineColor }
        if let existingText = self.text {
            let attributedString = NSAttributedString(string: existingText, attributes: newAttributes)
            self.attributedText = attributedString
        }
        defaultAttributes = newAttributes
    }

    public func updateAttributes(
        font: UIFont? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        numberOfLines: Int? = nil,
        backgroundColor: UIColor? = nil,
        underlineStyle: NSUnderlineStyle? = nil,
        underlineColor: UIColor? = nil
    ) {
        var newAttributes: StringAttributes = defaultAttributes
        if let font { newAttributes[.font] = font }
        if let color { newAttributes[.foregroundColor] = color }
        if let alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            newAttributes[.paragraphStyle] = paragraphStyle
            self.textAlignment = alignment
        }
        if let numberOfLines { self.numberOfLines = numberOfLines }
        if let backgroundColor { newAttributes[.backgroundColor] = backgroundColor }
        if let underlineStyle { newAttributes[.underlineStyle] = underlineStyle.rawValue }
        if let underlineColor { newAttributes[.underlineColor] = underlineColor }
        defaultAttributes = newAttributes
    }
}
