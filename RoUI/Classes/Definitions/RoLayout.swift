//
//  RoLayout.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 31.05.23.
//

import Foundation
import AppKit

/// Objekt zum bilden von Layoutconstraints.
///
/// Die verwendeten Abstände werden im LayoutModel definiert. Die Constraints werden zur Superview hinzugefügt
public struct RoLayout {
    /// Beschreibt an welche Seite die View an die SuperView geheftet werden soll
    public enum AttributeToSuper: CaseIterable {
        case top
        case bottom
        case leading
        case trailing
        
        /// Liefert das passenden LayoutConstraint-Attribute
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
            }
        }
        /// Liefert die Attribute um eine View auf allen Seiten anzuhängen
        public static var full: [AttributeToSuper] { [.leading, .top, .trailing, .bottom]}
        /// Liefert die Attribute um eine View links, oben und rechts anzuhängen
        public static var fullTop: [AttributeToSuper] { [.leading, .top, .trailing]}
        /// Liefert die Attribute um eine View links, unten und rechts anzuhängen
        public static var fullBottom: [AttributeToSuper] { [.leading, .bottom, .trailing]}
        /// Liefer die Attribute um eine View links und rechts anzuhängen
        public static var fullLine: [AttributeToSuper] {[.leading, .trailing]}
    }
    /// Ausrichtung von Views innerhable der Superview
    public enum AttributeBetween {
        case horizontal
        case vertical
        
        /// Attribut für die erste View
        var firstViewAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .horizontal:
                return .right
            case .vertical:
                return .bottom
            }
        }
        /// Attribut für die zweite View]
        var secondViewAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .horizontal:
                return .left
            case .vertical:
                return .top
            }
        }
    }
    /// Beschreibt die Ausrichtung von horizontalausgerichteten Views
    public enum LayoutHorizontal {
        case centerY
        case top
        case bottom
        /// Liefert das passenden LayoutConstraint-Attribute
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
    /// Beschreibt die Grössenconstraints einer View
    public enum LayoutSize {
        case width
        case height
        /// Liefert das passenden LayoutConstraint-Attribute
        public var attribute: NSLayoutConstraint.Attribute {
            switch self {
            case .width:
                return.width
            case .height:
                return .height
            }
        }
    }
    public enum Relation {
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
    /// Initialiseren eines Layouts
    /// - Parameters:
    ///   - model: Das Layoutmodel
    ///   - superView: Die Superview
    ///
    ///   Die Constraints werden der Superview hinzugefügt
    public init(model: LayoutModel, superView: NSView) {
        self.model = model
        self.superView = superView
    }
    public let model: LayoutModel
    public let superView: NSView
    
    /// Fügt die View als Subview zur Superview falls sie noch nicht hinzugefügt wurde
    /// - Parameter view: Die Subview
    fileprivate func pAddSubviewIfNoteExists(_ view: NSView) {
        if view == superView { return }
        if !superView.subviews.contains(view) {
            superView.addSubviewForAutoLayout(view)
        }
    }

}
// MARK: - NSLayoutConstraints erstellen
extension RoLayout {
    func singleViewConstraint(view: NSView,
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
        //print("singleViewConstraint: \(constraint)")
    }
    func doubleViewConstraint(firstview: NSView,
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
        pAddSubviewIfNoteExists(secondview)
        superView.addConstraint(constraint)
        constraint.isActive = true
        //print("doubleViewConstraint: \(constraint)")

    }

    func addViewRelatedToSuper(_ view: NSView,
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
    func addLeftRightViews( leftView: NSView,
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
    func addToDownViews( upperView: NSView,
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

}
// MARK: - Public Functions für LayoutConstraints
extension RoLayout {
    /// Bildet die Constrains zweier Views innerhalb der Superview
    /// - Parameters:
    ///   - firstView: Erste View
    ///   - secondView: Zweite View
    ///   - type: Der Constrainttyp
    ///   - laOperator: Der Operator
    public func lcViewToView(firstView: NSView,
                             secondView: NSView,
                             type: RoLayout.AttributeBetween,
                             relation: RoLayout.Relation = .eq) {
        doubleViewConstraint(firstview: secondView,
                             secondview: firstView,
                             firstattribut: type.secondViewAttribute,
                             secondattribut: type.firstViewAttribute,
                             related: relation.relation,
                             multiplier: 1,
                             constant: model.valueForType(type))
    }
    /// Bildet die Constrains um die View an eine Seite der Superview zu heften
    /// - Parameters:
    ///   - view: Die View
    ///   - type: Der Type
    ///   - laOperator: Der Operateor (Default .eq)
    public func lcViewToSuper(view: NSView,
                              type: RoLayout.AttributeToSuper,
                              relation: RoLayout.Relation = .eq) {
        addViewRelatedToSuper(view,
                              attribute: type.attribute,
                              relation: relation.relation,
                              constant: model.valueForType(type))
    }
    /// Bildet die Constrains um die View an mehrere Seiten der Superview zu heften
    /// - Parameters:
    ///   - view: Die View
    ///   - types: Der Types
    ///   - laOperator: Der Operateor (Default .eq)
    public func lcViewToSuper(view: NSView,
                              types: [RoLayout.AttributeToSuper],
                              relation: RoLayout.Relation = .eq) {
        for type in types {
            addViewRelatedToSuper(view,
                                  attribute: type.attribute,
                                  relation: relation.relation,
                                  constant: model.valueForType(type))
        }
    }
    /// Bildet die Constrains um mehrere Views an mehrere Seiten der Superview zu heften
    /// - Parameters:
    ///   - views: Die Views
    ///   - types: Der Types
    ///   - laOperator: Der Operateor (Default .eq)
    public func lcViewsToSuper(views: [NSView], 
                               types: [RoLayout.AttributeToSuper],
                               relation: RoLayout.Relation = .eq) {
        views.forEach({
            self.lcViewToSuper(view: $0, types: types, relation: relation)
        })
    }
    /// Ordnet die Views von links nach Rechts ohne sie an die Superview zu heften
    /// - Parameters:
    ///   - views: Die Views (von Links nach Rechts)
    ///   - layoutHorizontal: Die Ausrichtung (Default centerY)
    public func lcLine(views: [NSView], layoutHorizontal: RoLayout.LayoutHorizontal = .centerY) {
        guard let firstView = views.first, views.count > 1 else { return }
        lcSameAttribute(views: views, attribute: layoutHorizontal.attribute)
        var leftView = firstView
        for idx in 1..<views.count {
            let rightView = views[idx]

            addLeftRightViews(leftView: leftView,
                              rightView: rightView,
                              relation: .equal,
                              constant: model.horizontal)
            leftView = rightView
        }
    }
    /// Ordnet die Views von links nach Rechts und heftet sie an die Superview
    /// - Parameters:
    ///   - views: Die Views (von Links nach Rechts)
    ///   - layoutHorizontal: Die Ausrichtung (Default centerY)
    ///   - fitLast: true: die rechte View wird mit eq an die Superview geheftet. Sonst mit le
    public func lcLineToSuper(views: [NSView], layoutHorizontal: RoLayout.LayoutHorizontal = .centerY, fitLast: Bool = true) {
        guard let firstView = views.first, let lastView = views.last else { return }
        lcLine(views: views, layoutHorizontal: layoutHorizontal)
        lcViewToSuper(view: firstView, type: .leading)
        lcViewToSuper(view: lastView, type: .trailing, relation: fitLast ? .eq : .le)
    }
    /// Ordnet die Views von Oben nach Unten an ohne an die Superview zu heften
    /// - Parameter views: Die Views (von Oben nach Unten)
    public func lcColumn(views: [NSView]) {
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
    /// Ordnet die Views von Oben nach Unten an ohne an die Superview zu heften
    /// - Parameter views: Die Views (von Oben nach Unten)
    ///   - fitLast: true: die untere View wird mit eq an die Superview geheftet. Sonst mit le
    public func lcColumnToSuper(views: [NSView], fitLast: Bool = true) {
        guard let firstView = views.first, let lastView = views.last else { return }
        lcColumn(views: views)
        lcViewToSuper(view: firstView, type: .top)
        let oper = fitLast ? Relation.eq : Relation.le
        lcViewToSuper(view: lastView, type: .bottom, relation: oper)
    }
    
    /// Bildet die Constraints für die Viewgrösse
    /// - Parameters:
    ///   - view: Die View
    ///   - size: Die Richtung
    ///   - constant: Die Grösse
    ///   - constraintOperator: Der Operator (Default eq)
    public func lcViewSize(view: NSView,
                           size: LayoutSize,
                           constant: CGFloat,
                           relation: Relation = .eq) {
        singleViewConstraint(view: view,
                             attribut: size.attribute,
                             related: relation.relation,
                             multiplier: 1,
                             constant: constant)
    }
    public func lcSameAttribute(views: [NSView], attribute: NSLayoutConstraint.Attribute) {
        guard let firstView = views.first, views.count > 1 else { return }
        for idx in 1..<views.count {
            let view = views[idx]
            doubleViewConstraint(firstview: view,
                                 secondview: firstView,
                                 firstattribut: attribute,
                                 secondattribut: attribute,
                                 related: .equal,
                                 multiplier: 1,
                                 constant: 0)
        }
    }
    /// Heftet die eine View links, die Andere rechts an die Superview.
    /// - Parameters:
    ///   - leftView: Die linke View
    ///   - rightView: Die rechte View
    ///   - layoutHorizontal: Die horizontale Ausrichtung (Default centerY)
    public func lcLeftRightViewToSuper(leftView: NSView, rightView: NSView, layoutHorizontal: RoLayout.LayoutHorizontal = .centerY) {
        lcViewToSuper(view: leftView, type: .leading)
        lcViewToSuper(view: rightView, type: .trailing)
        addLeftRightViews(leftView: leftView,
                          rightView: rightView,
                          relation: .greaterThanOrEqual,
                          constant: model.horizontal)
        doubleViewConstraint(firstview: rightView,
                             secondview: leftView,
                             firstattribut: layoutHorizontal.attribute,
                             secondattribut: layoutHorizontal.attribute,
                             related: .equal,
                             multiplier: 1,
                             constant: 0)

    }
}
// MARK: - LayoutModel
extension RoLayout {
    /// Das Layoutmodell definiert die Abstände die beim erstellen der Constrains verwendet werden.
    public struct LayoutModel {

        public static var modelView: LayoutModel {
            return LayoutModel(top: 10, bottom: -10, leading: 10, trailing: -10, horizontal: 8, vertical: 8)
        }
        public static var modelTableCellView: LayoutModel {
            return LayoutModel(top: 3, bottom: -3, leading: 0,trailing: -0, horizontal: 8, vertical: 8)
        }
        public static var modelOutlineCellView: LayoutModel {
            return LayoutModel(top: 2, bottom: -2, leading: 2,trailing: -3, horizontal: 8, vertical: 8)
        }
        public static var modelPopoverView: LayoutModel {
            return LayoutModel(top: 8, bottom: -8, leading: 8, trailing: -8, horizontal: 8, vertical: 8)
        }
        public static var modelZero: LayoutModel {
            return LayoutModel()
        }
        public static var modelZeroBorder: LayoutModel {
            return LayoutModel(horizontal: 8, vertical: 8)
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
        public func valueForType(_ type: AttributeToSuper) -> CGFloat {
            switch type {
            case .top:
                return top
            case .bottom:
                return bottom
            case .leading:
                return leading
            case .trailing:
                return trailing
            }
        }
        public func valueForType(_ type: AttributeBetween) -> CGFloat {
            switch type {
            case .horizontal: return horizontal
            case .vertical: return vertical
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
