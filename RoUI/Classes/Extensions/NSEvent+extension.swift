//
//  NSEvent+extension.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 11.02.22.
//

import Foundation
import AppKit
extension NSEvent {
    /// Prüfen ob nur die gewünschten Control-Keys gedrückt sind
    ///
    /// Es werden die Keys .shift, .control, .option, .command beachted
    /// - Parameter keys: Die Gewünschten Keys
    /// - Returns: true - wenn nur die gewünschten Keys gedrückt sind
    public func areOnlyControlKeysPressed(_ keys: [NSEvent.ModifierFlags]) -> Bool {
        let avableKeys: [NSEvent.ModifierFlags] = [.shift, .control, .option, .command]
        // Erst mal Testen ob alle gewünschten Keys gedrückt sind
        for key in keys {
            if !modifierFlags.contains(key) { return false}
        }
        // Alle gewünschten sind gedrückt
        // jetzt noch testen ob keine zusätzlichen gedrückt sind
        for avableKey in avableKeys {
            if modifierFlags.contains(avableKey) && !keys.contains(avableKey) {
                return false
            }
        }
        // Es ist alles ok
        return true
    }
}
