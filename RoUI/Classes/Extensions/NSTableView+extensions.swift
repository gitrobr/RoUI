//
//  NSTableView+extensions.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 23.08.23.
//

import Foundation
import AppKit

extension NSTableView {
    /// Bestimmt wo eine neue Zeilte eingefügt wird
    public enum InsertType {
        /// An der selektierten Zeile oder am Anfang
        case insert
        /// Nach der selektierten Zeile oder am Ende
        case append
    }
    /**
     Selektiert die Zeile und verschiebt sie in die Mitte der Liste
     - parameter row: Index der Zeile
     - parameter animated: scrollt animiert
     */
    public func centreRow(row: Int, animated: Bool) {
        self.selectRowIndexes(IndexSet.init(integer: row), byExtendingSelection: false)
        let rowRect = rect(ofRow: row)
        if let scrollView = self.enclosingScrollView {

            let centredPoint
                = CGPoint(x: 0.0,
                          y: rowRect.origin.y + (rowRect.size.height / 2) - ((scrollView.frame.size.height) / 2))
            if animated {
                scrollView.contentView.animator().setBoundsOrigin(centredPoint)
            } else {
                self.scroll(centredPoint)
            }
        }
    }
    /// Ermittelt anhand der Selection auf welcher Zeile ein neues Objekt eingefügt werden soll
    ///
    /// - Wenn keine Zeile ausgewählt ist wird am Anfang eingefügt
    /// - Wenn eine Zeile ausgewählt ist wird auf dieser Zeile eingefügt
    /// - Returns: Die Zeile für das neue Objekt
    @available(*, deprecated, message: "Use rowFroNewObjekt(type:)")
    public func newObjectRow() -> Int {
        if selectedRow < 0 { return 0 }
        return selectedRow
    }
    /// Liefert die Zeile in welcher ein neues Objekt eingefügt wird
    /// - Parameter type: Die Art des Einfügens
    /// - Returns: Die Zeile
    public func rowForNewObjekt(type: InsertType) -> Int {
        if selectedRow < 0 {
            switch type {
            case .insert:
                return 0
            case .append:
                return numberOfRows
            }
        }
        switch type {
        case .insert:
            return selectedRow
        case .append:
            return selectedRow + 1
        }
    }
    /// Fügt eine neue Zeile in die Tabelle und wählt diese aus
    /// - Parameter row: Zeile an der die neue Tabellenzeile eingefügt wird
    public func insertAndSelectRow(at row: Int) {
        insertRows(at: row.indexSet, withAnimation: .slideInsert)
        selectRowIndexes(row.indexSet, byExtendingSelection: false)
        scrollRowToVisible(row)
    }
    /// Löscht die angegebene Zeile und wählt die nächstgelegene aus
    /// - Parameter row: Die Zeile die gelöscht wird
    public func removeRowAndSelectNextRow(at row: Int) {
        removeRows(at: row.indexSet, withAnimation: .slideDelete)
        let newRow = if numberOfRows == 0 {
            -1
        } else if row >= numberOfRows - 1 {
            numberOfRows - 1
        } else {
            row
        }
        if newRow >= 0 {
            selectRowIndexes(newRow.indexSet, byExtendingSelection: false)
        }
    }
}
extension NSTableView.AnimationOptions {
    /// Animation beim Einfügen eines Objekts in die Tabelle
    public static var slideInsert: NSTableView.AnimationOptions { .slideLeft }
    /// Animation beim Löschen eines Objekts aus der Tabelle
    public static var slideDelete: NSTableView.AnimationOptions { .slideRight }
}
