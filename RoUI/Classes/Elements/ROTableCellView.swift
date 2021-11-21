//
//  ROTableCellView.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 20.11.21.
//

import Cocoa

/// Basisklasse einer TableCellView
///
/// Die Funktionen:
/// ```
/// func getContentView() -> NSView
/// func setIsEditableTo(_ editable: Bool )
/// ```
/// müssen in der abgeleiteten Klasse überschriben werden.
open class ROTableCellView: NSView {
    /// initialisieren
    /// - Parameter column: Column-Definition
    /// - Parameter layout: Mit diesem Layout wird die ContentView in die View gefügt
    required public init(column: ROTableColumnDefinition,
                         layout: ROLayoutConstantGroup,
                         withBottomLine: Bool = false) {
        pColumn = column
        pLayoutGroup = layout
        pWithBottomLine = withBottomLine
        super.init(frame: CGRect())
        translatesAutoresizingMaskIntoConstraints = false
        pSetupUI()
        setIsEditableTo(column.isEditable)
    }
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    /// Die Definition der Column
    public var column: ROTableColumnDefinition { pColumn }
    /// Setzt den Objektwert.
    ///
    /// Folgende überschreibbaren Funktionen werden aufgerufen
    /// ```
    /// func setIsEditableTo(_ editable: Bool )
    /// func didSetObjectValue()
    /// ```
    public var objectValue: Any? {
        get { pObjectValue }
        set {
            pObjectValue = newValue
            pDidSetObjectValue(ovverriedEditable: nil)
        }
    }
    /// Setzt den obejctValue. Gleichzeitig kann der isEditable-Wert von der Column-Definition überschrieben werden
    ///
    /// Folgende überschreibbaren Funktionen werden aufgerufen
    /// ```
    /// func setIsEditableTo(_ editable: Bool )
    /// func didSetObjectValue()
    /// ```
    /// - Parameters:
    ///   - ovalue: Der Objektwert
    ///   - editable: ¨Pberschreibt das Column-Definition isEditable-Flag
    public func setObjectValue(_ ovalue: Any?, ovverriedEditable editable: Bool?) {
        pObjectValue = ovalue
        pDidSetObjectValue(ovverriedEditable: editable)
    }
    /// Die Funktion liefert die Content-View
    ///
    /// Diese Funktion muss in der abgeleiteten Klasse überschrieben werden
    /// - Returns: Die Content-View
    open func getContentView() -> NSView { fatalError("Muss in den abgeleiteten Klassen definier sein") }
    /// Diese Funktion wird beim setzen des Objektwertes aufgerufen
    /// - Parameter editable: isEditabe aus der Column-Definition oder der überschreibene Wert
    open func setIsEditableTo(_ editable: Bool ) { fatalError("Muss in den abgeleiteten Klassen definier sein") }
    /// Wird aufgerufen wenn der objectValue gesetzt wird
    open func didSetObjectValue() { }
    private let pColumn: ROTableColumnDefinition
    private var pObjectValue: Any?
    private var pLayoutGroup: ROLayoutConstantGroup
    private let pWithBottomLine: Bool
    private func pDidSetObjectValue(ovverriedEditable editable: Bool?) {
        let isEditable = editable ?? pColumn.isEditable
        setIsEditableTo(isEditable)
        didSetObjectValue()
    }
    private func pSetupUI() {
        let cview = getContentView()
        addSubviewsForAutoLayout([cview])
        addConstraints(pLayoutGroup.cFull(view: cview, to: self))
    }
    open override func draw(_ dirtyRect: NSRect) {
        super .draw(dirtyRect)
        if pWithBottomLine {
            let context = NSGraphicsContext.current?.cgContext
            context?.beginPath()
            context?.move(to: CGPoint(x: 0, y: 0))
            context?.addLine(to: CGPoint(x: self.bounds.width, y: 0))
            context?.setStrokeColor(NSColor.textColor.cgColor)
            context?.setLineWidth(1)
            context?.strokePath()
        }
    }
}
