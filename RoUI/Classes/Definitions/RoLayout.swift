//
//  RoLayout.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 31.05.23.
//

import Foundation
import AppKit

public struct RoLayout {
    public enum ConstraintType: CaseIterable {
        case top
        case bottom
        case leading
        case trailing
        case horizontal
        case vertical

        public var attribute: NSLayoutConstraint.Attribute {
            switch self {
            case .top:
                return .top
            case .bottom:
                return .bottom
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .horizontal:
                return .left
            case .vertical:
                return .top
            }
        }
        public var opositeAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .top:
                return .top
            case .bottom:
                return .bottom
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .horizontal:
                return .right
            case .vertical:
                return .bottom
            }
        }
    }
    public enum LayoutHorizontal {
        case centerY
        case top
        case bottom

        public var attribute: NSLayoutConstraint.Attribute {
            switch self {
            case .centerY:
                return .centerY
            case .top:
                return .top
            case .bottom:
                return .bottom
            }
        }
    }

    public enum ConstraintOperator {
        case eq
        case le
        case ge

        public var relation: NSLayoutConstraint.Relation {
            switch self {
            case .eq:
                return .equal
            case .le:
                return .lessThanOrEqual
            case .ge:
                return .greaterThanOrEqual
            }
        }
    }
    public init(model: LayoutModel, superView: NSView) {
        self.model = model
        self.superView = superView
    }
    public let model: LayoutModel
    public let superView: NSView

    fileprivate func pAddSubviewIfNoteExists(_ view: NSView) {
        print("add \(view)")
        if !superView.subviews.contains(view) {
            superView.addSubviewForAutoLayout(view)
        }
    }

}
extension RoLayout {
    public func singleViewConstraint(view: NSView,
                              attribut: NSLayoutConstraint.Attribute,
                              related: NSLayoutConstraint.Relation,
                              multiplier: CGFloat,
                              constant: CGFloat) {
        let constraint = NSLayoutConstraint(item: view,
                                            attribute: attribut,
                                            relatedBy: related,
                                            toItem: nil,
                                            attribute: attribut,
                                            multiplier: multiplier,
                                            constant: constant)
        pAddSubviewIfNoteExists(view)
        superView.addConstraint(constraint)
        constraint.isActive = true
        print("singleViewConstraint: \(constraint)")
    }
    public func doubleViewConstraint(firstview: NSView,
                              secondview: NSView,
                              firstattribut: NSLayoutConstraint.Attribute,
                              secondattribut: NSLayoutConstraint.Attribute,
                              related: NSLayoutConstraint.Relation,
                              multiplier: CGFloat,
                              constant: CGFloat) {
        let constraint = NSLayoutConstraint(item: firstview,
                                            attribute: firstattribut,
                                            relatedBy: related,
                                            toItem: secondview,
                                            attribute: secondattribut,
                                            multiplier: multiplier,
                                            constant: constant)
        pAddSubviewIfNoteExists(firstview)
        //pAddSubviewIfNoteExists(secondview)
        superView.addConstraint(constraint)
        constraint.isActive = true
        print("doubleViewConstraint: \(constraint)")

    }

    public func addViewRelatedToSuper(_ view: NSView,
                               attribute: NSLayoutConstraint.Attribute,
                               relation: NSLayoutConstraint.Relation,
                               constant: CGFloat) {

        doubleViewConstraint(firstview: view,
                             secondview: superView,
                             firstattribut: attribute,
                             secondattribut: attribute,
                             related: relation,
                             multiplier: 1,
                             constant: constant)
    }
    public func addLeftRightViews( leftView: NSView,
                            rightView: NSView,
                            relation: NSLayoutConstraint.Relation,
                            constant: CGFloat) {

        doubleViewConstraint(firstview: rightView,
                             secondview: leftView,
                             firstattribut: .left,
                             secondattribut: .right,
                             related: relation,
                             multiplier: 1,
                             constant: constant)
    }
    public func addToDownViews( upperView: NSView,
                         lowerView: NSView,
                         relation: NSLayoutConstraint.Relation,
                         constant: CGFloat) {

        doubleViewConstraint(firstview: lowerView,
                             secondview: upperView,
                             firstattribut: .top,
                             secondattribut: .bottom,
                             related: relation,
                             multiplier: 1,
                             constant: constant)
    }

    public func lcViewToSuper(view: NSView, type: RoLayout.ConstraintType, laOperator: RoLayout.ConstraintOperator = .eq) {
        addViewRelatedToSuper(view,
                              attribute: type.attribute,
                              relation: laOperator.relation,
                              constant: model.valueForType(type))
    }
    public func lcViewToSuper(view: NSView, types: [RoLayout.ConstraintType], laOperator: RoLayout.ConstraintOperator = .eq) {
        for type in types {
            addViewRelatedToSuper(view,
                                  attribute: type.attribute,
                                  relation: laOperator.relation,
                                  constant: model.valueForType(type))
        }
    }
    public func lcLineToSuper(views: [NSView], layoutHorizontal: RoLayout.LayoutHorizontal = .centerY, fitLast: Bool = true) {
        guard let firstView = views.first, let lastView = views.last else { return }
        lcLine(views: views, layoutHorizontal: layoutHorizontal)
        lcViewToSuper(view: firstView, type: .leading)
        lcViewToSuper(view: lastView, type: .trailing, laOperator: fitLast ? .eq : .le)
    }
    public func lcLine(views: [NSView], layoutHorizontal: RoLayout.LayoutHorizontal = .centerY) {
        guard let firstView = views.first, views.count > 1 else { return }
        var leftView = firstView
        for idx in 1..<views.count {
            let rightView = views[idx]

            addLeftRightViews(leftView: leftView,
                              rightView: rightView,
                              relation: .equal,
                              constant: model.horizontal)
            doubleViewConstraint(firstview: rightView,
                                 secondview: firstView,
                                 firstattribut: layoutHorizontal.attribute,
                                 secondattribut: layoutHorizontal.attribute,
                                 related: .equal,
                                 multiplier: 1,
                                 constant: 0)

            leftView = rightView
        }
    }
    public func lcColumns(views: [NSView]) {
        guard let firstView = views.first, views.count > 1 else { return }
        var upperView = firstView
        for idx in 1..<views.count {
            let lowerView = views[idx]

            addToDownViews(upperView: upperView,
                           lowerView: lowerView,
                           relation: .equal,
                           constant: model.vertical)

            upperView = lowerView
        }
    }
    public func lcColumnsToSuper(views: [NSView]) {
        guard let firstView = views.first, let lastView = views.last else { return }
        lcColumns(views: views)
        lcViewToSuper(view: firstView, type: .top)
        lcViewToSuper(view: lastView, type: .bottom)
    }
}

extension RoLayout {
    public struct LayoutModel {

        public static var modelView: LayoutModel {
            return LayoutModel(top: 10, bottom: -10, leading: 10, trailing: -10, horizontal: 8, vertical: 8)
        }
        public static var modelZero: LayoutModel {
            return LayoutModel()
        }

        public init(top: CGFloat = 0,
             bottom: CGFloat = 0,
             leading: CGFloat = 0,
             trailing: CGFloat = 0,
             horizontal: CGFloat = 0,
             vertical: CGFloat = 0) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
            self.horizontal = horizontal
            self.vertical = vertical
        }
        public func valueForType(_ type: ConstraintType) -> CGFloat {
            switch type {
            case .top:
                return top
            case .bottom:
                return bottom
            case .leading:
                return leading
            case .trailing:
                return trailing
            case .horizontal:
                return horizontal
            case .vertical:
                return vertical
            }
        }
        /// Oben zur BasisView
        public let top: CGFloat
        /// Unten zur BasisView
        public let bottom: CGFloat
        /// Links zur BasisView
        public let leading: CGFloat
        /// Rechts zur BasisView
        public let trailing: CGFloat
        /// Horizontal zwischen den Elementen
        public let horizontal: CGFloat
        /// Vertikal zwischen den Elementen
        public let vertical: CGFloat
    }
}

/*
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
*/
