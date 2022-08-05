//
//  NSMenuItem+extensions.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 12.02.22.
//

import Foundation
import AppKit

extension NSMenuItem {
    static public func menuItem( title: String,
                                 action: Selector? = nil,
                                 keyEquivalent: String = "",
                                 keyEquivalentModifierFlag: NSEvent.ModifierFlags? = nil) -> NSMenuItem {
        let menu = NSMenuItem( title: title,
                               action: action,
                               keyEquivalent: keyEquivalent)
        if let keyeq = keyEquivalentModifierFlag {
            menu.keyEquivalentModifierMask = keyeq
        }
        return menu
    }
}
