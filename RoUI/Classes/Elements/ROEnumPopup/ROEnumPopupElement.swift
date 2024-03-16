//
//  ROEnumPopupElement.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 01.01.2024.
//

import Foundation

public protocol ROEnumPopupElement: CaseIterable, Comparable {
    /// Beschreibung die im PopupButton angezeigt wird wenn das Element ausgewählt ist
    var popupDescription: String { get }
    /// ToolTip der im PopupButton angezeigt wird wenn das Element ausgewählt ist
    var popupToolTip: String { get }
}
