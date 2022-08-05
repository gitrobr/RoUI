//
//  NSWindow+extension.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 29.01.22.
//

import Foundation
import AppKit

extension NSWindow {
    public func setFrameOriginToPositionWindowInCenterOfScreen() {
        if let screenSize = screen?.frame.size {
            self.setFrameOrigin(NSPoint(x: (screenSize.width-frame.size.width)/2, y: (screenSize.height-frame.size.height)/2))
        }
    }
    /**
     Zeigt einen Alert als Sheed im Fenste an.
     - parameter error: Fehler - wird in informationText geschrieben
     - parameter messageText: Titel ( Default: LocalizableError.titleErrorGeneral )
     - parameter answer: Wird beim Beenden des Dialogs ausgeführt
     */
    public func dialogErrorSheet(error: Error,
                                 messageText: String,
                                 answer: ((NSApplication.ModalResponse) -> Void)? = nil ) {
        let dialog = NSAlert()
        dialog.messageText = messageText
        dialog.informativeText = error.localizedDescription
        dialog.alertStyle = NSAlert.Style.critical
        dialog.beginSheetModal(for: self) { (dialogAnswer) in
            if let ans = answer {
                ans(dialogAnswer)
            }
        }
    }

}
