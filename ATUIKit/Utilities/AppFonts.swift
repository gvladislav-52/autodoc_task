//
//  AppFonts.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 21.07.2026.
//

import Foundation
import UIKit

public enum FontFamily {
    case roboto(Roboto)

    public enum Roboto: String {
        case medium = "Roboto-Medium"
        case regular = "Roboto-Regular"
        case bold = "Roboto-Bold"
        case boldItalic = "Roboto-BoldItalic"
        case black = "Roboto-Black"
        case blackItalic = "Roboto-BlackItalic"
        case italic = "Roboto-Italic"
        case light = "Roboto-Light"
        case lightItalic = "Roboto-LightItalic"
        case mediumItalic = "Roboto-MediumItalic"
        case thin = "Roboto-Thin"
        case thinItalic = "Roboto-ThinItalic"
    }
}

public enum AppFonts {
    public static let headline1: UIFont = .appFont(family: .roboto(.medium), size: 42, weight: .medium)
    public static let headline2: UIFont = .appFont(family: .roboto(.regular), size: 32, weight: .regular)
    public static let headline3: UIFont = .appFont(family: .roboto(.regular), size: 24, weight: .regular)
    public static let headline4: UIFont = .appFont(family: .roboto(.medium), size: 20, weight: .medium)
    public static let subtitle: UIFont = .appFont(family: .roboto(.regular), size: 17, weight: .regular)
    public static let subtitleBold: UIFont = .appFont(family: .roboto(.bold), size: 17, weight: .bold)
    public static let body: UIFont = .appFont(family: .roboto(.regular), size: 15, weight: .regular)
    public static let bodyBold: UIFont = .appFont(family: .roboto(.bold), size: 15, weight: .bold)
    public static let button: UIFont = .appFont(family: .roboto(.medium), size: 16, weight: .medium)
    public static let small: UIFont = .appFont(family: .roboto(.regular), size: 13, weight: .regular)
    public static let smallBold: UIFont = .appFont(family: .roboto(.bold), size: 13, weight: .bold)
    public static let caption: UIFont = .appFont(family: .roboto(.regular), size: 12, weight: .regular)
    public static let captionBold: UIFont = .appFont(family: .roboto(.bold), size: 12, weight: .bold)
    public static let overline: UIFont = .appFont(family: .roboto(.medium), size: 12, weight: .regular)
    public static let verySmall: UIFont = .appFont(family: .roboto(.medium), size: 10, weight: .medium)
}
