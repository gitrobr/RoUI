//
//  ROLocalizable.swift
//  RoUI
//
//  Created by seco on 27.03.21.
//

import Foundation
extension String {

    public func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
}
/**
 ````
 enum LocalizableStrings: String, BRLocalizable {
   case loadingData = "loading_data"
   case dataLoaded = "data_loaded"
   case jobserverFunction = "jobserver_function"

   var tableName: String {
     return "Localizable"
   }
 }
````

 ````
 let str = LocalizableStrings.jobserverFunction.localized
 ````
 */
public protocol ROLocalizable {
    static var bundle: Bundle { get }
    static var tableName: String { get }
    var localized: String { get }
    var rawString: String { get }
    func localized( dict: [String: String] ) -> String
}

// 1
extension ROLocalizable where Self: RawRepresentable, Self.RawValue == String {
    public var localized: String {
        return rawValue.localized(bundle: lacalizeBundle(Self.bundle), tableName: Self.tableName)
    }
    public var localizedLabel: String {
        return rawValue.localized(bundle: lacalizeBundle(Self.bundle), tableName: Self.tableName) + ":"
    }
    public var rawString: String {
        return rawValue
    }

    public func localized( dict: [String: String] ) -> String {
        var res = rawValue.localized(bundle: lacalizeBundle(Self.bundle), tableName: Self.tableName)
        for rec in dict {
            res = res.replacingOccurrences(of: "{\(rec.key)}", with: rec.value )
        }
        return res
    }
    private func lacalizeBundle(_ bundle: Bundle) -> Bundle {
        if let lang = Locale.preferredLanguages.first {
            if lang.contains("-") {
                let key = String(lang.split(separator: "-").first ?? "x")
                if let path = bundle.path(forResource: key, ofType: "lproj") {
                    if let bund = Bundle(path: path) {
                        return bund
                    }
                }
            }
        }
        return bundle
    }
}
