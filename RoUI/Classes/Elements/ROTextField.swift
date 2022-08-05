//
//  ROTextField.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 16.03.22.
//

import Foundation
import AppKit

@objc public protocol ROTextFieldDelegate: NSTextFieldDelegate {
    @objc optional func textFieldDidChangeText(_ textField: ROTextField)
}

open class ROTextField: NSTextField {

    public var didFinishChange: ((_ field: ROTextField) -> Void)?
    public var didChange: ((_ field: ROTextField) -> Void)?
    private var pOldObjectValue: String = ""
    open override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        if pOldObjectValue != self.stringValue {
            if let function = didFinishChange {
                function(self)
            }
            if let delegate = delegate as? ROTextFieldDelegate {
                delegate.textFieldDidChangeText?(self)
            }
        }
        return true
    }
    open override func textDidChange(_ notification: Notification) {
        if let callback = didChange {
            callback(self)
        }
    }
    open override func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        pOldObjectValue = self.stringValue
        return true
    }
}
