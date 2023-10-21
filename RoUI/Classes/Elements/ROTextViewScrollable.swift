//
//  ROTextViewScrollable.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 21.01.23.
//

import Foundation
import AppKit

open class ROTextViewScrollable: NSTextView {
    /// Mit der Tab-Taste wird zum nächsten Responder gesprungen
    public var useTabToJump: Bool = true
    public convenience init() {
        self.init( frame: CGRect())
    }
    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        pInit(frame: frameRect)
    }
    public override convenience init(frame frameRect: NSRect) {
        let test = NSTextView()
        self.init(frame: frameRect, textContainer: test.textContainer)
    }
    private func pInit(frame frameRect: NSRect) {
        isVerticallyResizable = true
        isHorizontallyResizable = true

        pScrollView = NSScrollView( frame: frameRect)

        pScrollView.hasVerticalScroller = true
        pScrollView.hasHorizontalScroller = true

        pScrollView.borderType = .bezelBorder
        pScrollView.focusRingType = .exterior

        translatesAutoresizingMaskIntoConstraints = true
        autoresizingMask = [.width, .height]
        isEditable = true
        pScrollView.documentView = self
    }
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    /// Die ScrollView
    public var scrollView: NSScrollView { self.pScrollView }
    private var pScrollView: NSScrollView!

    public var didReginFirstResponder: ((_ field: NSTextView) -> Void)?
    open override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        if resign, let didReginFirstResponder {
            didReginFirstResponder(self)
        }
        return resign
    }

    open override func insertTab(_ sender: Any?) {
        if useTabToJump {
            self.window?.selectNextKeyView(self)
            return
        }
        super.insertTab(sender)
    }
    open override func insertBacktab(_ sender: Any?) {
        if useTabToJump {
            self.window?.selectPreviousKeyView(self)
            return
        }
        super.insertBacktab(sender)
    }
}
