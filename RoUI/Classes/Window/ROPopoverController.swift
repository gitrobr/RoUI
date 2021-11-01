//
//  ROPopoverController.swift
//  RoUI
//
//  Created by seco on 01.04.21.
//

import Cocoa

@objc public protocol ROPopoverControllerDelegate: AnyObject {

}

open class ROPopoverController: NSViewController {

    public init(behavior: NSPopover.Behavior) {

        self.pPopover = NSPopover()
        super.init(nibName: nil, bundle: nil)
        self.pPopover.behavior = behavior
        self.pPopover.contentViewController = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public weak var delegate: ROPopoverControllerDelegate?

    public func show( relativeTo positioningView: NSView, preferredEdge: NSRectEdge) {
        self.pPopover.show(relativeTo: positioningView.bounds,
                           of: positioningView,
                           preferredEdge: preferredEdge)
    }
    public func closePopover() {
        self.pPopover.close()
    }

    // MARK: private
    private let pPopover: NSPopover
}
