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
}
