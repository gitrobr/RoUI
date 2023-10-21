//
//  ROStepper.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 29.07.23.
//

import Foundation
import AppKit

public protocol ROStepperFieldDelegate: AnyObject {
    func stepperFieldDidChangeValue( _ stepperField: ROStepperField)
}
/**
 Das StepperField beinhaltet ein NSStepper und ein Anzeigefeld
 */
open class ROStepperField: NSView {
    /// Standard Stepper für Tempo eingabe
    public init() {
        super.init(frame: CGRect() )
        self._setupView()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public weak var delegate: ROStepperFieldDelegate?
    /// Normal erhöhen / verringern
    public var incrementNormal: Double {
        get { self._stepper.incrementNormal }
        set {
            self._stepper.incrementNormal = newValue
            self._setStepperToolTip()
        }
    }
    /// Mit Shift erhöhen / verringern
    public var incrementShift: Double {
        get { self._stepper.incrementShift }
        set {
            self._stepper.incrementShift = newValue
            self._setStepperToolTip()
        }
    }
    /// Der maximal Wert
    public var maxValue: Double {
        get { self._stepper.maxValue }
        set {
            let prev = self._stepper.doubleValue
            self._stepper.maxValue = newValue
            self._testField.objectValue = self._stepper.doubleValue
            if prev != self._stepper.doubleValue {
                self.delegate?.stepperFieldDidChangeValue(self)
            }
        }
    }
    /// Der minimal Wert
    public var minValue: Double {
        get { self._stepper.minValue }
        set {
            let prev = self._stepper.doubleValue
            self._stepper.minValue = newValue
            self._testField.objectValue = self._stepper.doubleValue
            if prev != self._stepper.doubleValue {
                self.delegate?.stepperFieldDidChangeValue(self)
            }
        }
    }

    public var objectValue: Any? {
        get { self._stepper.objectValue }
        set {
            self._stepper.objectValue = newValue
            self._testField.objectValue = newValue
        }
    }
    public var integerValue: Int { return self._stepper.integerValue }
    public var doubleValue: Double { return self._stepper.doubleValue }

    public var isEditable: Bool {
        get { self._stepper.isEnabled }
        set { self._stepper.isEnabled = newValue}
    }
    /// Das Anzeigeformat
    public var formatter: Formatter? {
        get { self._testField.formatter }
        set { self._testField.formatter = newValue }
    }
    /// Tooltip für das Anzeigeelement
    open override var toolTip: String? {
        get { self._testField.toolTip }
        set { self._testField.toolTip = newValue }
    }
    /// Simuliert einen Klick auf den oberen Pfeil
    public func normalStepUp() {
        self._stepper.normalStepUp()
        self.actionStepper(self._stepper)
    }
    /// Simuliert einen Klick auf den unteren Pfeil
    public func normalStepDown() {
        self._stepper.normalStepDown()
        self.actionStepper(self._stepper)
    }

    @objc func actionStepper( _ sender: ROStepper ) {
        self._testField.objectValue = self._stepper.doubleValue
        self.delegate?.stepperFieldDidChangeValue(self)
    }

    private let _stepper: ROStepper = ROStepper()
    private let _testField: NSTextField = NSTextField()

    private func _setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self._stepper.target = self
        self._stepper.action = #selector(self.actionStepper(_:))
        self._setStepperToolTip()

        self._testField.alignment = .right
        self._testField.isEditable = false

        self.addSubviewsForAutoLayout([
            self._testField, self._stepper
        ])
        self.addConstraints([
            self._testField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self._testField.topAnchor.constraint(equalTo: self.topAnchor),
            self._testField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self._stepper.leadingAnchor.constraint(equalTo: self._testField.trailingAnchor),
            self._stepper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self._stepper.centerYAnchor.constraint(equalTo: self._testField.centerYAnchor),
            self._testField.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }

    private func _setStepperToolTip() {
        let str = """
        Normal Step: \(self._stepper.incrementNormal)
        Shift Step: \(self._stepper.incrementShift )
        """
        self._stepper.toolTip = str
    }
}

extension ROStepperField {
    open class ROStepper: NSStepper {
        /// Normal erhöhen / verringern
        public var incrementNormal: Double = 1
        /// Mit Shift erhöhen / verringenr
        public var incrementShift: Double = 10

        public func normalStepUp() {
            self.doubleValue += incrementNormal
        }
        public func normalStepDown() {
            self.doubleValue -= incrementNormal
        }

        open override func mouseDown(with event: NSEvent) {
            if event.modifierFlags.contains(.shift) {
                self.increment = incrementShift
            } else {
                self.increment = incrementNormal
            }
            super.mouseDown(with: event)
        }
        open override func keyDown(with event: NSEvent) {
            if event.modifierFlags.contains(.shift) {
                self.increment = incrementShift
            } else {
                self.increment = incrementNormal
            }
            super.keyDown(with: event)
        }
    }
}
