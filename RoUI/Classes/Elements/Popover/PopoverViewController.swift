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
/// ~~~
/// func addButtonsAtBottomOfView(upperView: NSView, layout: ROLayoutConstantGroup)
/// ~~~
/// werden die ok / canel Buttons unterhalb des angegebenen View und am Boden erstellt
///
/// Mit dern Funktionen:
/// ~~~
/// func willCloseOk() -> Bool { true }
/// func didCloseOk() {}
/// func willCloseCancel() -> Bool { true }
/// func didCloseCancel() {}
/// ~~~
/// kann in der abgeliteten Klasse die Aktion der Buttens gesteuert werden
class ROPopoverViewController: NSViewController {
    /// Initialisert das Popover
    /// - Parameter behavior: Das Verhalten (Default = .transient)
    init(behavior: NSPopover.Behavior = .transient) {
        pPopover = NSPopover()
        pPopover.behavior = behavior
        pPopover.animates = true

        super.init(nibName: nil, bundle: nil)

        pPopover.contentViewController = self

        buttonOk.action = #selector(self.actionButtons(_:))
        buttonCancel.action = #selector(self.actionButtons(_:))
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Der OK Button
    let buttonOk = NSButton.pushButtonOk
    /// Der Cancel Button
    let buttonCancel = NSButton.pushButtonCancel
    /// Anzeigen der Popovers
    /// - Parameters:
    ///   - view: Zu dieser View anzeigen
    ///   - preferredEdge: Die gewünschte Seite
    func show(relativeToView view: NSView, preferredEdge: NSRectEdge) {
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
    func willCloseOk() -> Bool { true }
    /// Wird aufgerufen wenn OK und das Popover schon geschlossen ist
    func didCloseOk() {}
    /// Wird aufgerufen wenn CANCEL geklickt wurde bevor das Popover geschlossen wird
    /// - Returns: false das Popover wird nicht geschlossen
    func willCloseCancel() -> Bool { true }
    /// Wird aufgerufen wenn CANCEL und das Popover schon geschlossen ist
    func didCloseCancel() {}
    /// Fügt OK und CANCEL ans untere Ende der View.
    ///
    /// Die upperView muss schon als Subview vorhanden sein
    /// - Parameter upperView: Unterhalb dieser View werden die Buttons platziert
    /// - Parameter layout: LayoutConstantGroup die zum Plazieren verwendet wird
    func addButtonsAtBottomOfView(upperView: NSView, layout: ROLayoutConstantGroup) {
        view.addSubviewsForAutoLayout([
            buttonOk, buttonCancel
        ])
        view.addConstraints(layout.cLeftRight(leftView: buttonOk,
                                                      rightView: buttonCancel, to: view))
        view.addConstraints(layout.cSameWitdh(views: [buttonOk, buttonCancel]))
        view.addConstraints([
            layout.vertical.cEQ(view: buttonOk, to: upperView),
            layout.bottom.cEQ(view: buttonOk, to: view)
        ])
    }
    /// Schliesst das Popover-Window
    func closePopover() {
        pPopover.close()
    }
    // MARK: - private
    private var pPopover: NSPopover

    override func loadView() {
        view = NSView()
    }
}
