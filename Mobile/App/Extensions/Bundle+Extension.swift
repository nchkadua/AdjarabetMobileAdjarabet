//
//  Bundle+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension Bundle {
    var coreAPIUrl: URL {
        URL(string: infoDictionary?["CORE_API_URL"] as? String ?? "")!
    }
}
