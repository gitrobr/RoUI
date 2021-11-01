//
//  NSController+extenstion.swift
//  RoSql
//
//  Created by seco on 15.04.21.
//

import Cocoa

public protocol ROSwitch: NSControl {
    var state: NSControl.StateValue { get set }
}

extension NSControl {
    static public var roswitch: ROSwitch {
        if #available(OSX 10.15, *) {
            return NSSwitch()
        } else {
            let button = NSButton(frame: NSRect(x: 0, y: 0, width: 24, height: 23))
            button.setButtonType(NSButton.ButtonType.switch)
            button.title = ""

            return button
        }
    }
}

@available(OSX 10.15, *)
extension NSSwitch: ROSwitch {}

extension NSButton: ROSwitch {}
