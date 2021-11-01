//
//  NSButton+extensions.swift
//  RoUI
//
//  Created by seco on 02.04.21.
//

import Cocoa

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
