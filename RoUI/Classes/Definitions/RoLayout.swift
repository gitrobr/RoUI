//
//  RoLayout.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 31.05.23.
//

import Foundation
import AppKit

open class RoLayout {
    public enum x {
        case eq
        case ge
        case le
    }
    public init(view: NSView, group: ROLayoutConstantGroup) {
        mainView = view
        self.group = group
    }
    private let mainView: NSView
    public let group: ROLayoutConstantGroup

    public func addFullToMain(view: NSView) {
        pAddSubviewIfNoteExists(view)
        mainView.addConstraints(group.cFull(view: view, to: mainView))
    }
    public func addTopFullWitdhToMain(view: NSView) {
        pAddSubviewIfNoteExists(view)
        mainView.addConstraints(group.cTopFullWitdh(view: view, to: mainView))
    }
    public func addBottomFullWitdhToMain(view: NSView) {
        pAddSubviewIfNoteExists(view)
        mainView.addConstraints(group.cBottomFullWitdh(view: view, to: mainView))
    }
    public func addFullHorizontal(views: [NSView]) {
        views.forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cFullHorizontal(views: views, to: mainView))
    }
    public func addVertical(views: [NSView]) {
        views.forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cVertical(views: views))
    }
    public func addVerticalToMain(views: [NSView], fitBottom: Bool = true) {
        views.forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cVerticalToSuper(views: views, to: mainView, fitBottom: fitBottom))
    }
    public func addLine(views: [NSView], layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY) {
        views.forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cLine(views: views, layoutHorizontal: layoutHorizontal))
    }
    public func addLineToMain(views: [NSView],
                              layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY,
                              fitLast: Bool = true) {
        views.forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cLineToSuper(views: views,
                                                   to: mainView,
                                                   layoutHorizontal: layoutHorizontal,
                                                   fitLast: fitLast))
    }
    public func addTopBottomToMain(view: NSView) {
        pAddSubviewIfNoteExists(view)
        mainView.addConstraints(group.cTopBottom(view: view, to: mainView))
    }
    public func addSameWitdh(views: [NSView]) {
        views.forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cSameWitdh(views: views))
    }
    public func addLinesToMain(lines: [[NSView]],
                              layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY,
                              fitLast: Bool = true) {
        lines.forEach({$0.forEach({pAddSubviewIfNoteExists($0)})})
        mainView.addConstraints(group.cLinesToSuper(lines: lines,
                                                    to: mainView,
                                                    layoutHorizontal: layoutHorizontal,
                                                    fitLast: fitLast))
    }
    public func addLeftRightToMain(leftView: NSView,
                                   rightView: NSView,
                                   layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY) {
        [leftView, rightView].forEach({pAddSubviewIfNoteExists($0)})
        mainView.addConstraints(group.cLeftRight(leftView: leftView,
                                                 rightView: rightView,
                                                 to: mainView,
                                                 layoutHorizontal: layoutHorizontal))
    }
    private func pAddSubviewIfNoteExists(_ view: NSView) {
        if !mainView.subviews.contains(view) {
            mainView.addSubviewForAutoLayout(view)
        }
    }
}
