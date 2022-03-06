//
//  ROLabelFieldPopoverController.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 05.03.22.
//

import Foundation
import AppKit

/// Ein Popover mit einem Label / Textfield / OK Button
open class ROLabelFieldPopoverController: ROPopoverViewController {
    public init() {
        pWidthContraintField = field.widthAnchor.constraint(equalToConstant: 300)
        super.init()
    }
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UI Elemetns
    let label = NSTextField.label
    let field = NSTextField()

    /// Öffnet das Popover
    /// - Parameters:
    ///   - view: Das Popover wird relative zu dieser View angezeigt
    ///   - preferredEdge: Die gewünschte Seite
    ///   - labelText: Der Labeltext
    ///   - fieldText: Der Text im TextField
    ///   - fieldWidth: Die Breite des TextField ( Default: 250 )
    ///   - didChoose: Aktion die bei OK durchgeführt wird
    public func show(relativeToView view: NSView,
                     preferredEdge: NSRectEdge,
                     labelText: String,
                     fieldText: String?,
                     fieldWidth: CGFloat = 250,
                     didChoose: @escaping (_ cntlrPopover: ROLabelFieldPopoverController) -> Void) {
        pWidthContraintField.constant = fieldWidth
        pDidChoose = didChoose
        show(relativeToView: view, preferredEdge: preferredEdge)
        label.objectValue = labelText
        field.objectValue = fieldText
    }
    // MARK: - result
    /// Wert aus dem TextField
    public var fieldText: String { field.stringValue }
    // MARK: - private
    private let pWidthContraintField: NSLayoutConstraint
    private var pDidChoose: ((_ cntlrPopover: ROLabelFieldPopoverController) -> Void)?
    // MARK: - override PopoverViewController
    open override func didCloseOk() {
        if let didChoose = pDidChoose {
            didChoose(self)
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
extension ROLabelFieldPopoverController {

    func setupUI() {
        pSetupUIElements()
        pSetupView()
    }

    private func pSetupUIElements() {
    }
    private func pSetupView() {
        view.addSubviewsForAutoLayout([
            label, field
        ])
        view.addConstraints(ROLayoutConstant.popover.cLineToSuper(views: [label, field], to: view))
        view.addConstraints([
            ROLayoutConstant.popover.top.cEQ(view: label, to: view),
            pWidthContraintField
        ])
        addButtonsAtBottomOfView(upperView: label, layout: ROLayoutConstant.popover)
    }
}
