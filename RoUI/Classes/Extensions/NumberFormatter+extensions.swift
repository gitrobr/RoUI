//
//  NumberFormatter+extensions.swift
//  RoUI
//
//  Created by seco on 01.04.21.
//

import Foundation

extension NumberFormatter {
    /// Integer Formatter
    static public var intFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0

        return formatter
    }

}
