//
//  ROWindow.swift
//  RoUI
//
//  Created by seco on 27.03.21.
//

import Cocoa

open class ROWindow: NSWindow {
    static public func window(
        contentRect: CGRect = CGRect(x: 10, y: 10, width: 300, height: 300),
        styleMask: NSWindow.StyleMask =  [ .titled, .resizable, .miniaturizable, .closable]
        ) -> ROWindow {

        let window = ROWindow(contentRect: contentRect, styleMask: styleMask, backing: .buffered, defer: false)
        return window
    }
}
