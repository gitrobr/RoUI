//
//  ROMenuItemTable.swift
//  RoUI
//
//  Created by seco on 01.04.21.
//

import Cocoa

/**
 Ein Menuitem für das Contextmenu in einer Table / Outline View
 */
open class ROMenuTable: NSMenu {
    /// Das menu wurde für die Row aufgerufen
    public var row: Int = -1
    /// Das menu wurde für die Column aufgerufen
    public var col: Int = -1
}
