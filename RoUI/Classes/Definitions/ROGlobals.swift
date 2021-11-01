//
//  ROGlobals.swift
//  RoUI
//
//  Created by seco on 28.03.21.
//

import Cocoa

public struct ROApp {
    public enum Appearance {
        case darkMode
        case lightMode
    }
    /// Zeigt an ob die App im light oder dark-Mode läuft
    public static var appearanceMode: ROApp.Appearance {
        if NSApp.effectiveAppearance.name == NSAppearance.Name.darkAqua { return .darkMode }
        return .lightMode
    }
}

public struct ROViewConstant {
    static public let leadingAnchor: CGFloat = 10.0
    static public let trailingAnchor: CGFloat = -10.0
    static public let topAnchor: CGFloat = 10.0
    static public let bottomAnchor: CGFloat = -10.0
    static public let hBetweenElements: CGFloat = 8.0
    static public let vBetweenElements: CGFloat = 8.0
}

public struct ROTableViewConstant {
    static public let leadingAnchor: CGFloat = 5.0
    static public let trailingAnchor: CGFloat = -5.0
    static public let topAnchor: CGFloat = 5.0
    static public let bottomAnchor: CGFloat = -5.0
    static public let hBetweenElements: CGFloat = 8.0
    static public let vBetweenElements: CGFloat = 3.0
}
