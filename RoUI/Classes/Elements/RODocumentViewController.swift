//
//  RODocumentViewController.swift
//  RoUI
//
//  Created by Bruno Roncaglioni on 06.10.2024.
//

import Foundation
import AppKit

open class RODocumentViewController<T: NSDocument>: NSViewController {
    required public init(document: T) {
        pDocument = document
        super.init(nibName: nil, bundle: nil)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var document: T {pDocument}
    private unowned var pDocument: T
}
