//
//  ColorPaletteProtocol.swift
//  ATUIKit
//
//  Created by gvladislav-52 on 21.07.2026.
//

import UIKit

public protocol ColorPaletteProtocol {
    var primaryBackground: UIColor { get }
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
    var actionButton: UIColor { get }
    var cardBackground: UIColor { get }
    var errorColor: UIColor { get }
}
