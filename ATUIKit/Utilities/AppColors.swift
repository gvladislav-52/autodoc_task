//
//  AppColors.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 21.07.2026.
//

import UIKit

public enum AppColors {
    public private(set) static var palette: ColorPaletteProtocol = DefaultPalette()

    @discardableResult
    public static func update(for userInterfaceStyle: UIUserInterfaceStyle) -> ColorPaletteProtocol {
        palette = userInterfaceStyle == .dark ? DarkModePalette() : DefaultPalette()
        return palette
    }

    private var userInterfaceStyle: UIUserInterfaceStyle {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first(where: \.isKeyWindow)?
            .traitCollection
            .userInterfaceStyle ?? .unspecified
    }
}

extension AppColors {
    struct DefaultPalette: ColorPaletteProtocol {
        let primaryBackground = UIColor(hex: "24272E")
        let primaryText = UIColor(hex: "F5F5F7")
        let secondaryText = UIColor(hex: "5A6270")
        let actionButton = UIColor(hex: "FFA94D")
        let cardBackground = UIColor(hex: "E4DED2")
        let errorColor = UIColor(hex: "A62037")
    }

    struct DarkModePalette: ColorPaletteProtocol {
        let primaryBackground = UIColor(hex: "24272E")
        let primaryText = UIColor(hex: "F5F5F7")
        let secondaryText = UIColor(hex: "5A6270")
        let actionButton = UIColor(hex: "FFA94D")
        let cardBackground = UIColor(hex: "E4DED2")
        let errorColor = UIColor(hex: "A62037")
    }
}
