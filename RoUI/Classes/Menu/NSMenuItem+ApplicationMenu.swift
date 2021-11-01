//
//  NSMenuItem+ApplicationMenu.swift
//  RoUI
//
//  Created by seco on 27.03.21.
//

import Cocoa

extension NSMenuItem {
    static public func menuItem( title: String,
                                 action: Selector? = nil,
                                 keyEquivalent: String = "") -> NSMenuItem {
        return NSMenuItem( title: title,
                           action: action,
                           keyEquivalent: keyEquivalent)
    }
    /**
     Das Applications Menu:

     Der Standardaufbau ist:
     - about
     - preferences
     - seperator
     - hide
     - hide orher
     - show all
     - seperator
     - quit
     */
    static public func standardAppMenuItemApplication() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.application.localized)
        item.submenu = NSMenu(title: LocalizableStandardMenu.application.localized)
        return item
    }
    /**
     Standard File Menu
     */
    static public func standardAppMenuItemFile() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.file.localized)
        item.submenu = NSMenu(title: LocalizableStandardMenu.file.localized)
        return item
    }
    /**
     Standard Edit Menu

     - undo
     - redo
     - seperator
     - copy
     - paste
     - cut
     - select all
     */
    static public func standardAppMenuItemEdit() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.edit.localized)
        item.submenu = NSMenu(title: LocalizableStandardMenu.edit.localized)
        return item
    }
    // MARK: - application
    static public func menuAbout(appName: String) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.about.localized(dict: ["app": appName]),
                                       action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)))
        return item
    }
    static public func menuPreferences(action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.preferences.localized,
                                       action: action,
                                       keyEquivalent: ",")
        return item
    }
    static public func menuHide(appName: String) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.hide.localized(dict: ["app": appName]),
                                       action: #selector(NSApplication.hide(_:)),
                                       keyEquivalent: "h")
        return item
    }
    static public func menuHideOthers() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.hideOthers.localized,
                                       action: #selector(NSApplication.hide(_:)),
                                       keyEquivalent: "h")
        item.keyEquivalentModifierMask = [.command, .option]
        return item
    }
    static public func menuShowAll() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.showAll.localized,
                                       action: #selector(NSApplication.unhideAllApplications(_:)))
        return item
    }
    static public func menuQuit(appName: String) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.quit.localized(dict: ["app": appName]),
                                       action: #selector(NSApplication.terminate(_:)),
                                       keyEquivalent: "q")
        return item
    }
    // MARK: - file
    static public func menuOpenRecent() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.openRecent.localized)
        item.submenu = NSMenu(title: LocalizableStandardMenu.openRecent.localized)
        let clearItem = NSMenuItem.menuItem(title: LocalizableStandardMenu.openRecentClearMenu.localized,
                                            action: #selector(NSDocumentController.clearRecentDocuments(_:)))
        item.submenu?.items = [
            clearItem
        ]
        return item
    }
    static public func menuOpen( action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.open.localized,
                                       action: action,
                                       keyEquivalent: "o")
        return item
    }
    static public func menuSave( action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.save.localized,
                                       action: action,
                                       keyEquivalent: "s")
        return item
    }
    static public func menuSaveAs( action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.saveAs.localized,
                                       action: action,
                                       keyEquivalent: "S")
        return item
    }
    static public func menuNew( action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.new.localized,
                                       action: action,
                                       keyEquivalent: "n")
        return item
    }
    static public func menuClose() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.close.localized,
                                       action: #selector(NSWindow.performClose(_:)),
                                       keyEquivalent: "w")
        return item
    }
    // MARK: - edit
    static public func menuUndo( action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.undo.localized,
                                       action: action,
                                       keyEquivalent: "z")
        return item
    }
    static public func menuRedo( action: Selector) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.redo.localized,
                                       action: action,
                                       keyEquivalent: "Z")
        return item
    }
    static public func menuCopy() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.copy.localized,
                                       action: #selector(NSText.copy(_:)),
                                       keyEquivalent: "c")
        return item
    }
    static public func menuPaste() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.paste.localized,
                                       action: #selector(NSText.paste(_:)),
                                       keyEquivalent: "v")
        return item
    }
    static public func menuCut() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.cut.localized,
                                       action: #selector(NSText.cut(_:)),
                                       keyEquivalent: "x")
        return item
    }
    static public func menuSelectAll() -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: LocalizableStandardMenu.selectAll.localized,
                                       action: #selector(NSText.selectAll(_:)),
                                       keyEquivalent: "a")
        return item
    }

    static public func individualAppMenuItemApplication(name: ROLocalizable) -> NSMenuItem {
        let item = NSMenuItem.menuItem(title: name.localized)
        item.submenu = NSMenu(title: name.localized)
        return item
    }

}
