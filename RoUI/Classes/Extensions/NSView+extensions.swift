//
//  NSView+extensions.swift
//  RoUI
//
//  Created by seco on 31.03.21.
//

import Cocoa

extension NSView {
    /**
     View als Subview hinzufügen und translatesAutoresizingMaskIntoConstraints ausschalten.
     - parameter view: Wird als Subview hinzugefügt
     */
    public func addSubviewForAutoLayout(_ view: NSView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview( view )
    }
    /**
     Views werden als Subview hinzufügen und translatesAutoresizingMaskIntoConstraints ausschalten.
     - parameter views: View Array
     */
    public func addSubviewsForAutoLayout(_ views: [NSView] ) {
        for view in views {
            self.addSubviewForAutoLayout(view)
        }
    }
}
