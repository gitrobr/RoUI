//
//  ROLocalizableStandardMenu.swift
//  RoUI
//
//  Created by seco on 27.03.21.
//

import Foundation

public enum LocalizableStandardMenu: String, ROLocalizable {
    case about = "about"
    case application = "application"
    case bringAllToFront = "bring all to front"
    case capitalize = "capitalize"
    case checkDocumentNow = "check document now"
    case checkGrammarWithSpelling = "check grammar with spelling"
    case checkSpellingWhileTyping = "check spelling while typing"
    case close = "close"
    case copy = "copy"
    case correctSpellingAutomatically = "correct spelling automatically"
    case cut = "cut"
    case delete = "delete"
    case edit = "edit"
    case file = "file"
    case findAndReplace = "find and replace"
    case findNext = "find next"
    case findPrevious = "find previous"
    case find = "find"
    case help = "help"
    case hide = "hide"
    case hideOthers = "hide others"
    case jumpToSelection = "jump to selection"
    case makeLowerCase = "make lower case"
    case makeUpperCase = "make upper case"
    case minimize = "minimize"
    case new
    case open = "open"
    case openRecent
    case openRecentClearMenu
    case pasteAndMatchStyle = "paste and match style"
    case paste = "paste"
    case preferences = "preferences"
    case quit = "quit"
    case redo = "redo"
    case reset = "reset"
    case save = "save"
    case saveAs = "save as"
    case selectAll = "select all"
    case seperator = "seperator"
    case services = "services"
    case showAll = "show all"
    case showApellingAndGrammar = "show spelling and grammar"
    case showSubstitutions = "show substitutions"
    case smartCopyPaste = "smart copy/paste"
    case smartDashes = "smart dashes"
    case smartLinks = "smart links"
    case smartQuotes = "smart quotes"
    case speech = "speech"
    case spellingAndGrammar = "spelling and grammar"
    case spelling = "spelling"
    case startSpeaking = "start speaking"
    case stopSpeaking = "stop speaking"
    case substitutions = "substitutions"
    case textReplacement = "text replacement"
    case transformations = "transformations"
    case undo = "undo"
    case useSelectionForFind = "use selection for find"
    case useSelectionForReplace = "use selection for replace"
    case window = "window"
    case zoom = "zoom"

    public static var tableName: String {
        return "LocalizableStandardMenu"
    }
    public static var bundle: Bundle { Bundle(identifier: "ch.broncaglioni.RoUI") ?? .main }
}
