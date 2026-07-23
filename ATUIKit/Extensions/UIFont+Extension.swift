//
//  UIFont+Extension.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation
import UIKit

public extension UIFont {
    convenience init?(fontName name: String, size: CGFloat, weight: UIFont.Weight) {
        let descriptor = UIFontDescriptor(name: name, size: size)
        let traits = [UIFontDescriptor.TraitKey.weight: weight]
        let newDescriptor = descriptor.addingAttributes([.traits: traits])
        self.init(descriptor: newDescriptor, size: size)
    }

    static func appFont(family fontFamily: FontFamily, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        var fontName: String
        switch fontFamily {
        case let .roboto(roboto):
            fontName = roboto.rawValue
        }
        let font = UIFont(fontName: fontName, size: size, weight: weight)
        guard let font else {
            return UIFont()
        }
        return font
    }
}
