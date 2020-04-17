//
//  Rswift+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Rswift

public extension Rswift.StringResource {
    func localized(language: Language = Language.default) -> String {
        let path = Bundle(for: Language.Class.self).path(forResource: language.localizableIdentifier, ofType: "lproj")!
        let bundle = Bundle(path: path)!

        return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: "", comment: comment ?? "")
    }
}
