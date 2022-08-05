//
//  ROTabViewController.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 23.03.22.
//

import Foundation
import AppKit

@objc public protocol ROTabViewControllerDelegate: AnyObject {
    @objc optional func tabView(_ cntlrTabView: ROTabViewController, didSelect tabViewItem: NSTabViewItem?)
}

open class ROTabViewController: NSTabViewController {
    public unowned var delegate: ROTabViewControllerDelegate?
    open override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        delegate?.tabView?(self, didSelect: tabViewItem)
    }
}
