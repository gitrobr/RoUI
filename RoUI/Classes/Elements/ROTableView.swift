//
//  ROTableView.swift
//  RoUI
//
//  Created by seco on 04.04.21.
//

import Cocoa

@objc public protocol ROTableViewDelegate: NSTableViewDelegate {
    @objc optional func tableView(_ tableView: ROTableView, keyDown event: NSEvent, atRow row: Int ) -> Bool
    @objc optional func tableView(_ tableView: ROTableView, mouseDown event: NSEvent, atRow row: Int ) -> Bool

}

/// Erweiterte NSTableView
///
/// Die ROTableView ist in eine ScrollView eingebeted. Für Autolayout wird die scrollView verwendet
open class ROTableView: NSTableView {
    public convenience init() {
        self.init( frame: CGRect())
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.pScrollView = NSScrollView( frame: frameRect)
        self.pClipView   = NSClipView()

        self.pClipView.autoresizesSubviews = true
        self.pClipView.autoresizingMask = [ .height, .width ]

        pScrollView.contentView = self.pClipView
        pScrollView.hasVerticalScroller = true
        pScrollView.hasHorizontalScroller = true
        pClipView.documentView = self

        pScrollView.borderType = .bezelBorder
        pScrollView.focusRingType = .exterior

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// Die ScrollView
    public var scrollView: NSScrollView { self.pScrollView }
    public var withFocusRing: Bool {
        get { pScrollView.focusRingType == .exterior }
        set {
            pScrollView.focusRingType = newValue ? .exterior : .none
        }
    }
    /**
     Erstellt die Columns anhand der Definitionen. Die erste Column in den Definitionen ist
     auch die Outline-Column
     - parameter columns: Definitionen der Columns
     */
    public func setupColumns(_ columns: [ROTableColumnDefinition] ) {
        if columns.count == 0 { return }
        let firstColumn = columns[0]
        var column = NSTableColumn.tableColumnFromDefinition(firstColumn)
        if !firstColumn.hasHeader {
            self.headerView = nil
        }
        for index in 0..<columns.count {
            column = NSTableColumn.tableColumnFromDefinition(columns[index])
            self.addTableColumn(column)
        }

        return
    }
    /**
     Setzen des Shortcut für das öffnen des Contextmenu. Feuert die delegate funktion
     */
    public func setMenuSchortcut( keyCode: UInt16, modifier: NSEvent.ModifierFlags) {
        self.pMenuKey = keyCode
        self.pMenuOptions = modifier
    }

    // MARK: private
    private var pScrollView: NSScrollView!
    private var pClipView: NSClipView!
    private var pMenuOptions: NSEvent.ModifierFlags = [.option]
    private var pMenuKey: UInt16 = ROKeycode.m

    open override func keyDown(with event: NSEvent) {
        guard let delegate = self.delegate as? ROTableViewDelegate else {
            super.keyDown(with: event)
            return
        }
        // Wenn wir bis hier gekommen sind wird noch das delegae abgefragt
        if !(delegate.tableView?(self, keyDown: event, atRow: self.selectedRow) ?? false) {
            super.keyDown(with: event)
        }
    }
    open override func mouseDown(with event: NSEvent) {
        guard let delegate = self.delegate as? ROTableViewDelegate else {
            super.mouseDown(with: event)
            return
        }
        let globalLocation = event.locationInWindow
        let localLocation = convert(globalLocation, from: nil)
        let clickedRow = row(at: localLocation)

        if clickedRow >= 0 {
            if !(delegate.tableView?(self, mouseDown: event, atRow: clickedRow) ?? false) {
                super.mouseDown(with: event)
            }
        } else {
            super.mouseDown(with: event)
        }
    }
}
