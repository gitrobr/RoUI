//
//  NSTextField.swift
//  RoUI
//
//  Created by seco on 31.03.21.
//

import Cocoa

extension NSTextField {
    static public var wrappingLabel: NSTextField {
        let label = NSTextField.label
        if let cell = label.cell {
            cell.wraps = true
            cell.lineBreakMode = .byTruncatingTail
        }
        return label
    }

    static public var label: NSTextField {
        let textfield = NSTextField()
        textfield.isEditable = false
        textfield.isBordered = false
        textfield.drawsBackground = false
        return textfield
    }

    func setFontTraitMasek(_ fontTraitMask: NSFontTraitMask) {
        let fontmanager = NSFontManager.shared
        if let font = self.font {
            self.font = fontmanager.convert(font, toHaveTrait: fontTraitMask)
        }
    }

}
