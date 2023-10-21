//
//  Int+extension.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 09.09.23.
//

import Foundation

extension Int {
    /// Liefert das IndexSet mit dem Inhalt des Int
    public var indexSet: IndexSet {
        IndexSet(integer: self)
    }
}
