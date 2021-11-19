//
//  ROLocalizableUIElement.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 19.11.21.
//

import Foundation

public enum ROLocalizableUIElement: String, ROLocalizable {
    case roButtonOk
    case roButtonCancel
    public static var tableName: String {
        return "ROLocalizableUIElement"
    }
    public static var bundle: Bundle { Bundle(identifier: "ch.broncaglioni.RoUI") ?? .main }
}
