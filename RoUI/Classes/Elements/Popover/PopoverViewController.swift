//
//  PopoverViewController.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 19.11.21.
//

import Cocoa

/// Basisklasse eines Popovers
///
/// Mit der Funktion
/// ```
/// func addButtonsAtBottomOfView(upperView: NSView, layout: ROLayoutConstantGroup)
/// ```
/// werden die ok / canel Buttons unterhalb des angegebenen View und am Boden erstellt
///
/// Mit dern Funktionen:
/// ```
/// func willCloseOk() -> Bool { true }
/// func didCloseOk() {}
/// func willCloseCancel() -> Bool { true }
/// func didCloseCancel() {}
/// ```
/// kann in der abgeliteten Klasse die Aktion der Buttens gesteuert werden
open class ROPopoverViewController: NSViewController {
    /// Initialisert das Popover
    /// - Parameter behavior: Das Verhalten (Default = .transient)
    public init(behavior: NSPopover.Behavior = .transient) {
        pPopover = NSPopover()
        pPopover.behavior = behavior
        pPopover.animates = true

        super.init(nibName: nil, bundle: nil)

        pPopover.contentViewController = self

        buttonOk.target = self
        buttonOk.action = #selector(self.actionButtons(_:))
        buttonCancel.target = self
        buttonCancel.action = #selector(self.actionButtons(_:))
    }
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Der OK Button
    public let buttonOk = NSButton.pushButtonOk
    /// Der Cancel Button
    public let buttonCancel = NSButton.pushButtonCancel
    /// Anzeigen der Popovers
    /// - Parameters:
    ///   - view: Zu dieser View anzeigen
    ///   - preferredEdge: Die gewünschte Seite
    public func show(relativeToView view: NSView, preferredEdge: NSRectEdge) {
        pPopover.show(relativeTo: view.bounds, of: view, preferredEdge: preferredEdge)
    }
    @objc func actionButtons(_ sender: NSButton) {
        switch sender {
        case buttonOk:
            if willCloseOk() {
                closePopover()
                didCloseOk()
                return
            } else {
                return
            }
        case buttonCancel:
            if willCloseCancel() {
                closePopover()
                didCloseCancel()
                return
            } else {
                return
            }
        default:
            closePopover()
            return
        }
    }
    /// Wird aufgerufen wenn OK geklickt wurde bevor das Popover geschlossen wird
    /// - Returns: false das Popover wird nicht geschlossen
    open func willCloseOk() -> Bool { true }
    /// Wird aufgerufen wenn OK und das Popover schon geschlossen ist
    open func didCloseOk() {}
    /// Wird aufgerufen wenn CANCEL geklickt wurde bevor das Popover geschlossen wird
    /// - Returns: false das Popover wird nicht geschlossen
    open func willCloseCancel() -> Bool { true }
    /// Wird aufgerufen wenn CANCEL und das Popover schon geschlossen ist
    open func didCloseCancel() {}
    /// Fügt OK und CANCEL ans untere Ende der View.
    ///
    /// Die upperView muss schon als Subview vorhanden sein
    /// - Parameter upperView: Unterhalb dieser View werden die Buttons platziert
    /// - Parameter layout: das verwendete Layout
    public func addButtonsAtBottomOfView(upperView: NSView, layout: RoLayout) {
        layout.lcLeftRightViewToSuper(leftView: buttonOk, rightView: buttonCancel)
        layout.lcSameAttribute(views: [buttonOk, buttonCancel], attribute: .width)
        layout.lcViewToView(firstView: upperView, secondView: buttonOk, type: .vertical)
        layout.lcViewToSuper(view: buttonOk, type: .bottom)
    }
    /// Schliesst das Popover-Window
    public func closePopover() {
        pPopover.close()
    }
    // MARK: - private
    private var pPopover: NSPopover

    open override func loadView() {
        view = NSView()
    }
}
extension ROPopoverViewController: NSTextFieldDelegate {
    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.cancelOperation(_:)) {
            actionButtons(buttonCancel)
            return true
        }
        return false
    }
}
