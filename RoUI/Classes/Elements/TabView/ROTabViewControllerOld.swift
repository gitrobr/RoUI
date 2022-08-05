//
//  ROTabViewController.swift
//  RoUI
//
//  Created by seco on 05.04.21.
//

import Cocoa
/**
 Erweitert NSViewController um Element von TabView.
 */
public protocol ROViewControllerTabView: AnyObject {
    func setTabItem(_ tabitem: ROTabViewControllerOld.TabItemView)
}

@objc public protocol ROTabViewControllerDelegateOld: AnyObject {
    @objc func tabViewControllerSelectionDidChange(_ tabViewController: ROTabViewControllerOld)
    @objc func tabViewController(_ tabViewController: ROTabViewControllerOld, willClose cntlrView: NSViewController)
}

public class ROTabViewControllerOld: NSViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let cntlrTab = TabController()
    let viewContrainer = NSView()
    // MARK: public
    public weak var delegate: ROTabViewControllerDelegateOld?
    public func addViewController(_ viewController: NSViewController) {
        cntlrTab.addViewController(viewController)
    }
    public func numberOfTabsAfterClosingCurrent() -> Int {
        cntlrTab.closeCurrentTab()
        return cntlrTab.numberOfTabs
    }
    public var selectedViewController: NSViewController? {
        cntlrTab.selectedViewController
    }
    // MARK: private
    /// Die View-Controller der einzelnen Tabs
    private var pViewControllers: [TabItemToViewController] = []
    /// Indes des aktiven Tab ( -1 keiner )
    private var pCurrentItemIndex: Int = -1

    // MARK: overriede
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    public override func loadView() {
        self.view = NSView()
    }
}

extension ROTabViewControllerOld: TabControllerDelegate {
    func tabController(_ tabController: TabController, didCloseTabForViewController: NSViewController) {
        delegate?.tabViewController(self, willClose: didCloseTabForViewController)
    }

    func tabController(_ tabController: TabController, didCangeSelecttionFromIndex from: Int, toIndex: Int) {
        if let view = viewContrainer.subviews.first {
            view.removeFromSuperview()
        }
        if let cntlr = cntlrTab.viewControllerAt(toIndex) {
            viewContrainer.addSubviewForAutoLayout(cntlr.view)
            viewContrainer.addConstraints([
                cntlr.view.topAnchor.constraint(equalTo: viewContrainer.topAnchor),
                cntlr.view.leadingAnchor.constraint(equalTo: viewContrainer.leadingAnchor),
                cntlr.view.trailingAnchor.constraint(equalTo: viewContrainer.trailingAnchor),
                cntlr.view.bottomAnchor.constraint(equalTo: viewContrainer.bottomAnchor)
            ])
        }
        delegate?.tabViewControllerSelectionDidChange(self)
    }
}
