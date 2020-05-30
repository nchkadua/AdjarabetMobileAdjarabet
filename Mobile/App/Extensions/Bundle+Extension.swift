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

    var mobileAPIUrl: URL {
        URL(string: infoDictionary?["MOBILE_API_URL"] as? String ?? "")!
    }
    
    var versionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var fullVersion: String? {
        guard let versionNumber = versionNumber, let buildNumber = buildNumber else {return nil}

        return "\(versionNumber) (\(buildNumber))"
    }
}

