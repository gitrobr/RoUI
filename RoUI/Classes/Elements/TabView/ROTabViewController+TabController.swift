//
//  ROTabViewController+TabController.swift
//  RoUI
//
//  Created by seco on 05.04.21.
//

import Cocoa

protocol TabItemViewDelegate: AnyObject {
    func tabItemViewDidSelect(_ tabItemView: ROTabViewController.TabItemView)
    func tabItemViewWillClose(_ tabItemView: ROTabViewController.TabItemView)
}

protocol TabControllerDelegate: AnyObject {
    func tabController(_ tabController: ROTabViewController.TabController,
                       didCangeSelecttionFromIndex from: Int,
                       toIndex: Int)
    func tabController(_ tabController: ROTabViewController.TabController,
                       didCloseTabForViewController: NSViewController)
}
extension ROTabViewController {
    /**
     Der Controller für den Tab-Bereich
     */
    class TabController: NSViewController, TabItemViewDelegate {
        weak var delegate: TabControllerDelegate?

        func addViewController(_ viewController: NSViewController) {
            let firstIndexOfViewController = pViewControllers.firstIndex { (cntlr) -> Bool in
                return (cntlr.controller === viewController )
            }
            if let firstIndex = firstIndexOfViewController {
                let index = Int(firstIndex)
                // TODO: aktiveren des entsprechenden View-Controller
                return
            }
            let itemView = TabItemView()
            itemView.fieldTitle.objectValue = viewController.title
            itemView.delegate = self
            if let tabview = viewController as? ROViewControllerTabView {
                tabview.setTabItem(itemView)
            }
            let item = TabItemToViewController(view: itemView, controller: viewController)
            self.pAddItemAtTheEnde(item)
        }
        func closeCurrentTab() {
            pCloseTab(at: pCurrentItemIndex)
        }
        func viewControllerAt(_ index: Int ) -> NSViewController? {
            if index < 0 { return nil }

            return pViewControllers[index].controller
        }
        func tabItemViewDidSelect(_ tabItemView: ROTabViewController.TabItemView) {
            self.pSetCurrentIndex(self.pViewControllers.selectItemView(tabItemView))
        }
        func tabItemViewWillClose(_ tabItemView: ROTabViewController.TabItemView) {
            if let indexToDelete = firstIndexOfTabView(tabItemView) {
                pCloseTab(at: indexToDelete)
            }
        }
        var selectedViewController: NSViewController? {
            if pCurrentItemIndex < 0 { return nil }
            return pViewControllers[pCurrentItemIndex].controller
        }
        func firstIndexOfTabView(_ tabItemView: ROTabViewController.TabItemView) -> Int? {
            for (index,item) in pViewControllers.enumerated() {
                if item.view === tabItemView { return index }
            }
            return nil
        }
        var numberOfTabs: Int { pViewControllers.count }
        private var pScrollView: NSScrollView!
        private var pClipView: NSClipView!
        private var pDocumentView = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))

        /// Die View-Controller der einzelnen Tabs
        private var pViewControllers: [TabItemToViewController] = []
        /// Indes des aktiven Tab ( -1 keiner )
        private var pCurrentItemIndex: Int = -1

        private func pAddItemAtTheEnde(_ item: TabItemToViewController) {
            guard let lastTabView = pDocumentView.subviews.last else {
                self.addFirstTab(item)
                return
            }
            if let lastTrailingConstraint = pDocumentView.constraints.first(where: { (const) -> Bool in
                const.firstAttribute == .trailing && const.firstItem === lastTabView
            }) {
                pDocumentView.removeConstraint(lastTrailingConstraint)
            }
            pDocumentView.addSubviewForAutoLayout(item.view)
            pDocumentView.addConstraints([
                item.view.leadingAnchor.constraint(equalTo: lastTabView.trailingAnchor),
                item.view.trailingAnchor.constraint(equalTo: pDocumentView.trailingAnchor),
                item.view.topAnchor.constraint(equalTo: pDocumentView.topAnchor),
                item.view.bottomAnchor.constraint(equalTo: pDocumentView.bottomAnchor)
            ])
            pViewControllers.append(item)
            pSetCurrentIndex(pViewControllers.selectItemView(item.view))

        }
        private func pSetCurrentIndex(_ index: Int, sendAlways: Bool = false) {
            if pCurrentItemIndex != index {
                let oldIndex = pCurrentItemIndex
                pCurrentItemIndex = index
                self.delegate?.tabController(self, didCangeSelecttionFromIndex: oldIndex, toIndex: index)
            } else if sendAlways {
                self.delegate?.tabController(self, didCangeSelecttionFromIndex: index, toIndex: index)
            }
        }
        private func addFirstTab(_ item: TabItemToViewController) {
            pDocumentView.addSubviewForAutoLayout(item.view)

            pDocumentView.addConstraints([
                item.view.leadingAnchor.constraint(equalTo: pDocumentView.leadingAnchor),
                item.view.trailingAnchor.constraint(equalTo: pDocumentView.trailingAnchor),
                item.view.topAnchor.constraint(equalTo: pDocumentView.topAnchor),
                item.view.bottomAnchor.constraint(equalTo: pDocumentView.bottomAnchor)
            ])
            self.pViewControllers.append(item)
            pSetCurrentIndex(pViewControllers.selectItemView(item.view))
        }
        private func pCloseTab( at index: Int) {
            guard index >= 0  else { return }

            let previewView: NSView
            let nextView: NSView
            let firstView: Bool
            let lastView: Bool
            if index < 1 {
                previewView = pDocumentView
                firstView = true
            } else {
                previewView = pViewControllers[index - 1].view
                firstView = false
            }

            if index >= pViewControllers.count - 1 {
                nextView = pDocumentView
                lastView = true
            } else {
                nextView = pViewControllers[index + 1].view
                lastView = false
            }
            let element = pViewControllers.remove(at: index)
            element.view.removeFromSuperview()
            delegate?.tabController(self, didCloseTabForViewController: element.controller)
            
            if firstView && lastView {
                pSetCurrentIndex(-1)
                return
            }
            let newCurrent: Int
            if lastView {
                pDocumentView.addConstraint(
                    previewView.trailingAnchor.constraint(equalTo: pDocumentView.trailingAnchor))
                newCurrent = pViewControllers.count - 1
            } else if firstView {
                pDocumentView.addConstraint(nextView.leadingAnchor.constraint(equalTo: pDocumentView.leadingAnchor))
                newCurrent = index
            } else {
                pDocumentView.addConstraint(nextView.leadingAnchor.constraint(equalTo: previewView.trailingAnchor))
                newCurrent = index
            }
            pViewControllers[newCurrent].view.simulateClick()
            //pSetCurrentIndex(index, sendAlways: true)
        }
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        override func loadView() {
            self.pScrollView = NSScrollView( frame: CGRect())
            self.pClipView   = NSClipView()

            self.pClipView.autoresizesSubviews = true
            self.pClipView.autoresizingMask = [ .height, .width ]

            self.pScrollView.contentView = self.pClipView
            self.pScrollView.hasVerticalScroller = false
            self.pClipView.documentView = self.pDocumentView

            self.pScrollView.borderType = .bezelBorder

            self.pDocumentView.translatesAutoresizingMaskIntoConstraints = false

            self.view = self.pScrollView

        }
    }
    struct TabItemToViewController {
        let view: TabItemView
        let controller: NSViewController
    }
    public class TabItemView: NSView {
        static var tabItemHeight: CGFloat { 30 }

        init() {
            super.init(frame: CGRect())
            self.pSetupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        // MARK: UI Elemente
        let fieldTitle = NSTextField.label
        let fieldModified = NSTextField.label
        let buttonClose = NSButton.stopProgessButton
        let buttonMenu = NSButton.tabMenuButton

        weak var delegate: TabItemViewDelegate?

        public func setText(_ text: String) {
            fieldTitle.objectValue = text
        }

        var isSelected: Bool = false { didSet { self.pDidSetIsSelected() } }

        func simulateClick() {
            self.delegate?.tabItemViewDidSelect(self)
        }
        public func setTextColor(_ color: NSColor) {
            fieldTitle.textColor = color
        }
        public func setIsModified(_ modified: Bool) {
            fieldModified.objectValue = modified ? "*" : nil
        }
        public func resetTextColor() {
            fieldTitle.textColor = NSColor.textColor
        }
        @objc func actionCloseButton(_ sender: NSButton ) {
            delegate?.tabItemViewWillClose(self)
        }
        private func pDidSetIsSelected() {
            if self.isSelected {
                self.fieldTitle.setFontTraitMasek(.boldFontMask)
                self.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
            } else {
                self.fieldTitle.setFontTraitMasek(.unboldFontMask)
                self.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
            }
        }
        private func pSetupUI() {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.wantsLayer = true
            self.layer?.borderWidth = 1
            self.layer?.borderColor = NSColor.gray.cgColor
            self.pDidSetIsSelected()

            buttonClose.target = self
            buttonClose.action = #selector(self.actionCloseButton(_:))
            self.addSubviewsForAutoLayout([
                buttonClose, fieldModified, fieldTitle, buttonMenu
            ])

            self.addConstraints([
                buttonClose.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                fieldModified.leadingAnchor.constraint(equalTo: buttonClose.trailingAnchor, constant: 5),
                fieldTitle.leadingAnchor.constraint(equalTo: fieldModified.trailingAnchor),
                buttonMenu.leadingAnchor.constraint(greaterThanOrEqualTo: fieldTitle.trailingAnchor, constant: 5),
                buttonMenu.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),

                buttonClose.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                buttonClose.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                fieldModified.centerYAnchor.constraint(equalTo: buttonClose.centerYAnchor),
                fieldTitle.centerYAnchor.constraint(equalTo: buttonClose.centerYAnchor),
                buttonMenu.centerYAnchor.constraint(equalTo: buttonClose.centerYAnchor),

                fieldModified.widthAnchor.constraint(lessThanOrEqualToConstant: 10),
                buttonClose.heightAnchor.constraint(equalToConstant: 6),
                buttonClose.widthAnchor.constraint(equalToConstant: 6),

                buttonMenu.heightAnchor.constraint(equalTo: buttonClose.heightAnchor),
                buttonMenu.widthAnchor.constraint(equalTo: buttonClose.widthAnchor)
            ])
        }
        public override func mouseDown(with event: NSEvent) {
            self.delegate?.tabItemViewDidSelect(self)
        }
    }
}

extension Array where Element == ROTabViewController.TabItemToViewController {
    mutating func selectItemView(_ view: ROTabViewController.TabItemView) -> Int {
        var newIndex = -1
        for (index, object) in self.enumerated() {
            if object.view === view {
                object.view.isSelected = true
                newIndex = index
            } else {
                object.view.isSelected = false
            }
        }
        return newIndex
    }
    mutating func selectItemAt(_ index: Int ) -> Int {
        var newIndex = -1
        for (idx, object) in self.enumerated() {
            if idx == index {
                object.view.isSelected = true
                newIndex = idx
            } else {
                object.view.isSelected = false
            }
        }
        return newIndex
    }
}
