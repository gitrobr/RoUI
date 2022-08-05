//
//  NSButton+extensions.swift
//  RoUI
//
//  Created by seco on 02.04.21.
//

import Cocoa
import SwiftUI

extension NSButton {
    /**
     Neuer Push Button
     */
    static public var pushButton: NSButton {
        let button = NSButton()
        button.bezelStyle = .regularSquare
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)

        return button
    }
    /// Button mit Text ok und keyEquivalent "\r"
    static public var pushButtonOk: NSButton {
        let button = NSButton.pushButton
        button.title = ROLocalizableUIElement.roButtonOk.localized
        button.keyEquivalent = "\r"
        return button
    }
    /// Button mit Text cancel und keyEquivalent "esc"
    static public var pushButtonCancel: NSButton {
        let button = NSButton.pushButton
        button.title = ROLocalizableUIElement.roButtonCancel.localized
        let keyEquivalent: String
        if #available(macOS 11.0, *) {
            keyEquivalent = String(KeyEquivalent.escape.character)
        } else {
            keyEquivalent = "\u{1b}"
        }
        button.keyEquivalent = keyEquivalent
        return button
    }

    static public var stopProgessButton: NSButton {
        let button = NSButton()
        button.bezelStyle = .regularSquare
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        button.image = NSImage(named: NSImage.stopProgressTemplateName)
        button.imageScaling = .scaleProportionallyDown
        button.title = ""
        button.isBordered = false

        return button

    }
    static public var tabMenuButton: NSButton {
        let button = NSButton()
        button.bezelStyle = .regularSquare
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        let image = NSImage(named: NSImage.touchBarGoForwardTemplateName)
        button.image = image //?.rotated(by: 90)
        button.imageScaling = .scaleProportionallyDown
        button.title = ""
        button.isBordered = false

        return button

    }
}
