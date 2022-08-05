//
//  LayoutConstant.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 08.11.21.
//

import Cocoa

/// Constante für LayoutConstraints
///
/// Diese Klasse wird im Projekt überschreiben und mit den entsprechenden static Variablen erweitert.
/// z.B.
///
///     static let view = LayoutGroup(values: [.top: 10, .bottom: -10, .leading: 10,.trailing: -10, .horizontal: 8, .vertical: 8])
///

open class ROLayoutConstant {
    public enum LayoutType: CaseIterable {
        case top
        case bottom
        case leading
        case trailing
        case horizontal
        case vertical
    }
    public enum LayoutHorizontal {
        case centerY
        case top
        case bottom
    }
    /// Diese Gruppe hat überall 0 Abstand
    public static let zero = ROLayoutConstantGroup(values: [ROLayoutConstant.LayoutType: CGFloat]())
    public static let popover = ROLayoutConstantGroup(values: [.top: 8, .bottom: -8, .leading: 8,
                                                               .trailing: -8, .horizontal: 8, .vertical: 8])

}

/// Die LayoutInfos für eine Gruppe ( z.B. popup )
public struct ROLayoutConstantGroup {

    public init(values: [ROLayoutConstant.LayoutType: CGFloat]) {
        top = ROLayoutConstantValue(type: .top, value: values[.top] ?? 0)
        bottom = ROLayoutConstantValue(type: .bottom, value: values[.bottom] ?? 0)
        leading = ROLayoutConstantValue(type: .leading, value: values[.leading] ?? 0)
        trailing = ROLayoutConstantValue(type: .trailing, value: values[.trailing] ?? 0)
        horizontal = ROLayoutConstantValue(type: .horizontal, value: values[.horizontal] ?? 0)
        vertical = ROLayoutConstantValue(type: .vertical, value: values[.vertical] ?? 0)
    }
    /// Oben zur BasisView
    public let top: ROLayoutConstantValue
    /// Unten zur BasisView
    public let bottom: ROLayoutConstantValue
    /// Links zur BasisView
    public let leading: ROLayoutConstantValue
    /// Rechts zur BasisView
    public let trailing: ROLayoutConstantValue
    /// Horizontal zwischen den Elementen
    public let horizontal: ROLayoutConstantValue
    /// Vertikal zwischen den Elementen
    public let vertical: ROLayoutConstantValue

    /// Liefer alle LayoutConstraints um die View oben in der ganzen Breite zu platzieren
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cTopFullWitdh(view: NSView, to: NSView) -> [NSLayoutConstraint] {
        [
            leading.cEQ(view: view, to: to),
            top.cEQ(view: view, to: to),
            trailing.cEQ(view: view, to: to)
        ]
    }
    /// Liefer alle LayoutConstraints um die View unten in der ganzen Breite zu platzieren
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cBottomFullWitdh(view: NSView, to: NSView) -> [NSLayoutConstraint] {
        [
            leading.cEQ(view: view, to: to),
            bottom.cEQ(view: view, to: to),
            trailing.cEQ(view: view, to: to)
        ]
    }
    /// Liefer alle LayoutConstraints um die View ganz in die Relatet-View zu fügen
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cFull(view: NSView, to: NSView) -> [NSLayoutConstraint] {
        [
            leading.cEQ(view: view, to: to),
            top.cEQ(view: view, to: to),
            trailing.cEQ(view: view, to: to),
            bottom.cEQ(view: view, to: to)
        ]
    }
    /// Liefer alle LayoutConstraints um die Views  ganz in die Relatet-View zu fügen ( Horizontal / ohne center.y )
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cFullHorizontal(views: [NSView], to: NSView) -> [NSLayoutConstraint] {
        guard let firstView = views.first, let lastView = views.last else {
            return Array()
        }
        var result = [NSLayoutConstraint]()
        result.append(leading.cEQ(view: firstView, to: to))
        result.append(trailing.cEQ(view: lastView, to: to))
        var previewView: NSView?
        for view in views {
            result.append(contentsOf: [
                top.cEQ(view: view, to: to),
                bottom.cEQ(view: view, to: to)
            ])
            if let previewView = previewView {
                result.append(view.leadingAnchor.constraint(equalTo: previewView.trailingAnchor,
                                                            constant: horizontal.value))
            }
            previewView = view
        }
        return result
    }
    /// Die Views werden horizontal Angeordnet ohne an der Superview festzumachen
    /// - Parameters:
    ///   - views: Die Views
    ///   - layoutHorizontal: Zeigt die horizontale Ausrichtung (Default: centerY)
    /// - Returns: Die Constraints
    public func cLine(views: [NSView], layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        guard let firstView = views.first, views.count > 1 else { return constraints }
        var leftView = firstView
        for idx in 1..<views.count {
            let view = views[idx]
            constraints.append(horizontal.cEQ(view: view, to: leftView))
            switch layoutHorizontal {
            case .centerY: constraints.append(view.centerYAnchor.constraint(equalTo: firstView.centerYAnchor))
            case .top: constraints.append(view.topAnchor.constraint(equalTo: firstView.topAnchor))
            case .bottom: constraints.append(view.bottomAnchor.constraint(equalTo: firstView.bottomAnchor))
            }

            leftView = view
        }
        return constraints
    }
    /// Die Views werden in eine Linie gesetzt. Wobei das Erste und das Letzte am Rand festgemacht wird
    /// - Parameters:
    ///   - views: Die Views
    ///   - to: Superview
    ///   - layoutHorizontal: Zeigt die horizontale Ausrichtung
    ///   - fitLast: true: trailing an die Superview mit EQ sonst LE
    /// - Returns: Die Constraints
    public func cLineToSuper(views: [NSView],
                      to: NSView,
                      layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY,
                      fitLast: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        if views.count == 0 { return constraints }
        guard let firstView = views.first, let lastView = views.last else { return constraints }

        constraints.append(leading.cEQ(view: firstView, to: to))
        if fitLast {
            constraints.append(trailing.cEQ(view: lastView, to: to))
        } else {
            constraints.append(trailing.cLE(view: lastView, to: to))
        }
        constraints.append(contentsOf: cLine(views: views, layoutHorizontal: layoutHorizontal))
        return constraints
    }
    /// Die Views werden in eine Linie gesetzt. Wobei das Erste und das Letzte am Rand festgemacht wird
    /// - Parameters:
    ///   - lines: Eine Liste mit den enzelnen Zeilen
    ///   - to: Superview
    ///   - layoutHorizontal: Zeigt die horizontale Ausrichtung
    ///   - fitLast: true: trailing an die Superview mit EQ sonst LE
    /// - Returns: Die Constraints
    public func cLinesToSuper(lines: [[NSView]],
                       to: NSView,
                       layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY,
                       fitLast: Bool = true) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        lines.forEach({constraints.append(contentsOf: cLineToSuper(views: $0,
                                                                   to: to,
                                                                   layoutHorizontal: layoutHorizontal,
                                                                   fitLast: fitLast))})
        return constraints
    }
    /// Verbindet die Elemente vertikal mit einander. Es wird nicht an die Superview getackert
    /// - Parameters:
    ///   - views: Views
    /// - Returns: Die Constraints
    public func cVertical(views: [NSView]) -> [NSLayoutConstraint] {
        var constraitns = [NSLayoutConstraint]()
        guard let firstView = views.first, views.count > 1 else { return constraitns }
        var topView = firstView
        for idx in 1..<views.count {
            let view = views[idx]
            constraitns.append(vertical.cEQ(view: view, to: topView))
            topView = view
        }
        return constraitns
    }
    public func cVerticalToSuper(views: [NSView], to: NSView, fitBottom: Bool = true) -> [NSLayoutConstraint] {
        var constraitns = [NSLayoutConstraint]()
        guard let topView = views.first, let bottomView = views.last else { return constraitns }
        constraitns.append(contentsOf: cVertical(views: views))
        constraitns.append(top.cEQ(view: topView, to: to))
        if fitBottom {
            constraitns.append(bottom.cEQ(view: bottomView, to: to))
        } else {
            constraitns.append(bottom.cLE(view: bottomView, to: to))
        }
        return constraitns
    }
    /// Macht die Views gleich breit
    /// - Parameter views: Die Views
    /// - Returns: Die Constraints
    public func cSameWitdh(views: [NSView]) -> [NSLayoutConstraint] {
        var constraitns = [NSLayoutConstraint]()
        guard let firstView = views.first, views.count > 1 else { return constraitns }
        for idx in 1..<views.count {
            let view = views[idx]
            constraitns.append(view.widthAnchor.constraint(equalTo: firstView.widthAnchor))
        }
        return constraitns
    }
    /// Die View wird oben und unten an die Superview getackert
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Die Superview
    /// - Returns: Die Constraints
    public func cTopBottom(view: NSView, to: NSView) -> [NSLayoutConstraint] {
        [
            top.cEQ(view: view, to: to),
            bottom.cEQ(view: view, to: to)
        ]
    }
    public func cLeftRight(leftView: NSView, rightView: NSView, to: NSView,
                    layoutHorizontal: ROLayoutConstant.LayoutHorizontal = .centerY) -> [NSLayoutConstraint] {
        var constraints = [
            leading.cEQ(view: leftView, to: to),
            trailing.cEQ(view: rightView, to: to),
            horizontal.cGE(view: rightView, to: leftView)
        ]
        switch layoutHorizontal {
        case .centerY: constraints.append(rightView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor))
        case .top: constraints.append(rightView.topAnchor.constraint(equalTo: leftView.topAnchor))
        case .bottom: constraints.append(rightView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor))
        }
        return constraints
    }
}
public struct ROLayoutConstantValue {

    init( type: ROLayoutConstant.LayoutType, value: CGFloat) {
        pValue = value
        pType = type
    }
    /// Der Constant-Wert
    public var value: CGFloat { pValue }
    /// Liefer einen LayoutConstraint ( equalTo: constant: )
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cEQ(view: NSView, to: NSView) -> NSLayoutConstraint {
        switch pType {
        case .top:
            return view.topAnchor.constraint(equalTo: to.topAnchor, constant: pValue)
        case .bottom:
            return view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: pValue)
        case .leading:
            return view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: pValue)
        case .trailing:
            return view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: pValue)
        case .horizontal:
            return view.leadingAnchor.constraint(equalTo: to.trailingAnchor, constant: pValue)
        case .vertical:
            return view.topAnchor.constraint(equalTo: to.bottomAnchor, constant: pValue)
        }
    }
    /// Liefer einen LayoutConstraint ( greaterThanOrEqualTo: constant: )
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cGE(view: NSView, to: NSView) -> NSLayoutConstraint {
        switch pType {
        case .top:
            return view.topAnchor.constraint(greaterThanOrEqualTo: to.topAnchor, constant: pValue)
        case .bottom:
            return view.bottomAnchor.constraint(greaterThanOrEqualTo: to.bottomAnchor, constant: pValue)
        case .leading:
            return view.leadingAnchor.constraint(greaterThanOrEqualTo: to.leadingAnchor, constant: pValue)
        case .trailing:
            return view.trailingAnchor.constraint(greaterThanOrEqualTo: to.trailingAnchor, constant: pValue)
        case .horizontal:
            return view.leadingAnchor.constraint(greaterThanOrEqualTo: to.trailingAnchor, constant: pValue)
        case .vertical:
            return view.topAnchor.constraint(greaterThanOrEqualTo: to.bottomAnchor, constant: pValue)
        }
    }
    /// Liefer einen LayoutConstraint ( lessThanOrEqualTo: constant: )
    /// - Parameters:
    ///   - view: Die View
    ///   - to: Related to View
    /// - Returns: Der Constraint
    public func cLE(view: NSView, to: NSView) -> NSLayoutConstraint {
        switch pType {
        case .top:
            return view.topAnchor.constraint(lessThanOrEqualTo: to.topAnchor, constant: pValue)
        case .bottom:
            return view.bottomAnchor.constraint(lessThanOrEqualTo: to.bottomAnchor, constant: pValue)
        case .leading:
            return view.leadingAnchor.constraint(lessThanOrEqualTo: to.leadingAnchor, constant: pValue)
        case .trailing:
            return view.trailingAnchor.constraint(lessThanOrEqualTo: to.trailingAnchor, constant: pValue)
        case .horizontal:
            return view.leadingAnchor.constraint(lessThanOrEqualTo: to.trailingAnchor, constant: pValue)
        case .vertical:
            return view.topAnchor.constraint(lessThanOrEqualTo: to.bottomAnchor, constant: pValue)
        }
    }
    private let pValue: CGFloat
    private let pType: ROLayoutConstant.LayoutType
}
