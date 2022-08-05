//
//  ROTableCellViewText.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 06.03.22.
//

import Foundation
import AppKit

open class ROTableCellViewText: ROTableCellView, NSTextFieldDelegate {
    public init(column: ROTableColumnDefinition,
         formatter: Formatter? = nil,
         layout: ROLayoutConstantGroup,
         withBottomLine: Bool = false) {
        super.init(column: column, layout: layout, withBottomLine:  withBottomLine)
        pSetupTextField(formatter: formatter)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required public init(column: ROTableColumnDefinition) {
        super.init(column: column, layout: ROLayoutConstant.zero)
        pSetupTextField(formatter: nil)
    }

    required public init(column: ROTableColumnDefinition, layout: ROLayoutConstantGroup, withBottomLine: Bool = false) {
        fatalError("init(column:layout:withBottomLine:) has not been implemented")
    }
    public let fieldText = NSTextField()
    public var textDidChange: ((_ tcv: ROTableCellViewText) -> Void)?
    private var pTextBeforeEditing: String = ""
    public func controlTextDidEndEditing(_ obj: Notification) {
        if pTextBeforeEditing != fieldText.stringValue {
            if let callback = textDidChange {
                callback(self)
            }
        }
    }
    public func controlTextDidBeginEditing(_ obj: Notification) {
        pTextBeforeEditing = fieldText.stringValue
    }
    private func pSetupTextField(formatter: Formatter?) {
        fieldText.delegate = self
        fieldText.alignment = column.titleAlignment
        fieldText.isBordered = false
        fieldText.drawsBackground = false
        fieldText.formatter = formatter
    }
    // MARK: - override ROTableCellView
    override public func getContentView() -> NSView {
        fieldText
    }
    override public func setIsEditableTo(_ editable: Bool ) {
        fieldText.isEditable = editable
    }
    override public func didSetObjectValue() {
        fieldText.objectValue = objectValue
        pTextBeforeEditing = fieldText.stringValue
    }
}
