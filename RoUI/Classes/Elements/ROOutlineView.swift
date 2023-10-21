//
//  ROOutlineView.swift
//  RoUI
//
//  Created by seco on 31.03.21.
//

import Cocoa

@objc public protocol ROOutlineViewDelegate: NSOutlineViewDelegate {
    @objc optional func outlineView(_ outlineView: ROOutlineView, keyDown event: NSEvent, atRow row: Int ) -> Bool
    @objc optional func outlineView(_ outlineView: ROOutlineView, menuAtRow row: Int ) -> NSMenu?
    @objc optional func outlineView(_ outlineView: ROOutlineView, willDeleteRow row: Int ) -> Bool
}
/**
 Eine NSOutlineVIew in eine ScrollView eingebetet.

 Zum Einbetten in eine View muss man die scrollView verwenden
 */
open class ROOutlineView: NSOutlineView {

    public static func outlineViewWithColumns(_ columns: [ROTableColumnDefinition] ) -> ROOutlineView {
        let outlineView = ROOutlineView()
        outlineView.setupColumns(columns)
        return outlineView
    }
    public convenience init() {
        self.init( frame: CGRect())
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.pScrollView = NSScrollView( frame: frameRect)
        self.pClipView   = NSClipView()

        self.pClipView.autoresizesSubviews = true
        self.pClipView.autoresizingMask = [ .height, .width ]

        self.pScrollView.contentView = self.pClipView
        self.pScrollView.hasVerticalScroller = true
        self.pClipView.documentView = self

        self.pScrollView.borderType = .bezelBorder
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
        self.outlineTableColumn = column
        self.addTableColumn(column)
        if columns.count == 1 { return }
        for index in 1..<columns.count {
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
    public func tableCellViewForRow(_ row: Int, column: Int = 0) -> NSView? {
        return self.selectedRow >= 0 ? self.view(atColumn: column,
                                                 row: row,
                                                 makeIfNecessary: false) : nil
    }
    public func tableCellViewForSelectedRow(column: Int = 0) -> NSView? {
        return self.selectedRow >= 0 ? self.view(atColumn: column,
                                                 row: self.selectedRow,
                                                 makeIfNecessary: false) : nil
    }
    // MARK: private
    private var pScrollView: NSScrollView!
    private var pClipView: NSClipView!
    private var pMenuOptions: NSEvent.ModifierFlags = [.option]
    private var pMenuKey: UInt16 = ROKeycode.m

    // MARK: override
    open override func keyDown(with event: NSEvent) {
        guard let delegate = self.delegate as? ROOutlineViewDelegate else {
            super.keyDown(with: event)
            return
        }
        let tableCellView = self.tableCellViewForSelectedRow()

        // Menu Shortcut
        if event.keyCode == self.pMenuKey
            && self.pCheckCtrlAltDelete(toCheck: self.pMenuOptions, event: event) {
            if self.pKeyDownMenu(delegate: delegate, tableCellView: tableCellView) {
                return
            }
        }
        // Delete
        if event.keyCode == ROKeycode.delete
            && self.pCheckCtrlAltDelete(toCheck: .command, event: event) {
            if self.pKeyDownDelete(delegate: delegate) { return }
        }
        // Wenn wir bis hier gekommen sind wird noch das delegae abgefragt
        if !(delegate.outlineView?(self, keyDown: event, atRow: self.selectedRow) ?? false) {
            super.keyDown(with: event)
        }
    }
    private func pKeyDownDelete(delegate: ROOutlineViewDelegate) -> Bool {
        if self.selectedRow >= 0 {
            if delegate.outlineView?(self, willDeleteRow: self.selectedRow) ?? false {
                return true
            }
        }
        return false
    }
    private func pKeyDownMenu(delegate: ROOutlineViewDelegate, tableCellView: NSView?) -> Bool {
        if self.selectedRow < 0 {
            if let menu = delegate.outlineView?(self, menuAtRow: self.selectedRow),
               let cellview = self.headerView {
                let point = CGPoint(x: cellview.frame.size.width / 4, y: 0)
                menu.popUp(positioning: nil, at: point, in: cellview)
                return true
            }
        }
        if let cellview = tableCellView {
            if let menu = delegate.outlineView?(self, menuAtRow: self.selectedRow) {
                let point = CGPoint(x: cellview.frame.size.width / 4, y: 0)
                menu.popUp(positioning: nil, at: point, in: cellview)
                return true
            }
        }
        return false
    }
    private func pCheckCtrlAltDelete( toCheck: NSEvent.ModifierFlags, event: NSEvent ) -> Bool {
        let cmdAltCtlr: [NSEvent.ModifierFlags] = [.command, .option, .control]

        for flag in cmdAltCtlr {
            if toCheck.contains(flag) && event.modifierFlags.contains(flag) {
                // Flag ist in beiden alles ok
                continue
            }
            if toCheck.contains(flag) && !event.modifierFlags.contains(flag) {
                return false
            }
            if !toCheck.contains(flag) && event.modifierFlags.contains(flag) {
                return false
            }
        }
        return true
    }
}
