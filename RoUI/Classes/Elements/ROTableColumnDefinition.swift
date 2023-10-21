//
//  ROTableColumnDefinition.swift
//  RoUI
//
//  Created by seco on 31.03.21.
//

import Cocoa

/// Definiert eine Spalte einer TableView
public protocol ROTableColumnDefinition {
    /// Eindeutiger String der die Table definiert
    static var tableIdentifierString: String { get }
    /// Lacalizable Tabelle für den Titel
    static var localizeTableForColumnHeader: String { get }
    static var localizeTableForColumnTooltip: String { get }
    static var hasHeader: Bool { get }

    /// UserInterfaceItemIdentifier als String
    var identifierString: String { get }
    /// Überstetzter Titel
    var localizedHeader: String { get }
    var localizedHeaderTooltip: String { get }
    /// UserInterfaceItemIdentifier -> idetifier + ":" + Column
    var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier {get}

    /// ist die Spallte eiditierbar
    var isEditable: Bool { get }
    /// Textausrichtung der Titels
    var titleAlignment: NSTextAlignment { get }
    var hasHeader: Bool { get }
    var size: CGFloat? { get }
}

extension ROTableColumnDefinition where Self: RawRepresentable, Self.RawValue == String {
    public static var hasHeader: Bool { true }
    /// Identifier der Column ( TableIdetifinerString + ":" + Column.rawValue
    public var identifierString: String {
        "\(Self.tableIdentifierString):\(self.rawValue)"
    }
    public var localizedHeader: String {
        return NSLocalizedString(self.rawValue,
                                 tableName: Self.localizeTableForColumnHeader,
                                 bundle: .main,
                                 value: "**\(self.rawValue)**",
                                 comment: "")
    }
    public var localizedHeaderTooltip: String {
        return NSLocalizedString(self.rawValue,
                                 tableName: Self.localizeTableForColumnTooltip,
                                 bundle: .main,
                                 value: "**\(self.rawValue)**",
                                 comment: "")
    }
    public var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier( self.identifierString )
    }
    public var isEditable: Bool { false }
    public var titleAlignment: NSTextAlignment { .left }
    public var hasHeader: Bool { Self.hasHeader}
    public var size: CGFloat? { nil }
}
extension ROTableColumnDefinition where Self: CaseIterable {
    /// Liefert die Columndefinition anhand vom Columnidentifier
    /// - Parameter colIdentifier: Identifier der Column
    /// - Returns: Columndefinition
    public static func columnForIdentifier(_ colIdentifier: NSUserInterfaceItemIdentifier) -> ROTableColumnDefinition? {
        for item in Self.allCases where item.identifierString == colIdentifier.rawValue { return item }
        return nil
    }
    /// Liefert die Columndefinition anhand vom der Tabellenspalte
    /// - Parameter tableColumn: Die Tabellenspalte
    /// - Returns: Columndefinition
    public static func columnForTableColumn(_ tableColumn: NSTableColumn?) -> ROTableColumnDefinition? {
        guard let identifier = tableColumn?.identifier else { return nil }
        return Self.columnForIdentifier(identifier)
    }
}
extension NSTableColumn {
    static public func tableColumnFromDefinition(_ definition: ROTableColumnDefinition) -> NSTableColumn {
        let column = NSTableColumn(identifier: definition.userInterfaceItemIdentifier)
        if definition.hasHeader {
            column.title = definition.localizedHeader
            column.headerToolTip = definition.localizedHeaderTooltip
            column.headerCell.alignment = definition.titleAlignment
        }
        column.isEditable = definition.isEditable
        let dataCell = NSTextFieldCell()
        dataCell.isEditable = definition.isEditable
        dataCell.lineBreakMode = .byTruncatingTail
        column.dataCell = dataCell

        return column
    }
    static public var defaultTableColumnDefinition: ROTableColumnDefinition {
        enum Columns: String, ROTableColumnDefinition, CaseIterable {
            static var tableIdentifierString: String { "" }
            static var localizeTableForColumnHeader: String { "" }
            static var localizeTableForColumnTooltip: String { "" }

            case none
        }
        return Columns.none
    }
}


