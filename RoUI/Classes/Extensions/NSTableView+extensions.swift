//
//  NSTableView+extensions.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 23.08.23.
//

import Foundation
import AppKit

extension NSTableView {
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
    public func newObjectRow() -> Int {
        if selectedRow < 0 { return 0 }
        return selectedRow
    }
}
