//
//  ROEnumPopup.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 01.01.2024.
//

import Foundation
import AppKit

/// Ein Popup-Button zum Anzeigen einer enum (RoEnumPopupElement)
open class ROEnumPopup<Item: ROEnumPopupElement>: NSPopUpButton {
    /// Popup initzialisieren
    /// - Parameter sorted: Soll nach Beschreibung sortiert werden
    public init(sorted: Bool = true) {
        pSorted = sorted
        super.init(frame: CGRect(), pullsDown: false)
        target = self
        action = #selector(self.actionSelf(_:))
        pLoadData()
    }

    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    // MARK: - public
    public var selectionDidChange: ((Item) -> Void)?
    public var selectedEnumItem: Item { pData[pSelectedIndex] }
    open override func selectItem(at index: Int ) {
        pSelectedIndex = index
        super.selectItem(at: index)
    }
    public func selectItem(_ item: Item) {
        let index = pData.firstIndex(of: item) ?? 0
        selectItem(at: index)
    }
    public func selectNextItem() {
        if pSelectedIndex < pData.count - 1 { selectItem(at: pSelectedIndex + 1)}
    }
    public func selectPreviewItem() {
        if pSelectedIndex > 0 { selectItem(at: pSelectedIndex - 1)}
    }
    // MARK: - private
    private var pSorted: Bool
    private var pData: [Item] = []
    private var pSelectedIndex: Int = 0 { didSet { pCallbackWithCurrentItem() } }
    private func pLoadData() {
        if pSorted {
            pData = Item.allCases.sorted()
        } else {
            pData = Item.allCases.map({$0})
        }
        removeAllItems()
        addItems(withTitles: pData.map({ $0.popupDescription }))
        for (row, data) in pData.enumerated() {
            itemArray[row].toolTip = data.popupToolTip
        }
    }
    private func pCallbackWithCurrentItem() {
        if let callback = selectionDidChange {
            callback(selectedEnumItem)
        }
    }
    // MARK: - actions
    @objc func actionSelf( _ sender: NSPopUpButton ) {
        pSelectedIndex = indexOfSelectedItem
    }

}
