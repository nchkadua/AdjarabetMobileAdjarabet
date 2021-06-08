//
//  Bundle+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension Bundle {
    /**
     Returns Value of some String object from infoDictionary
     */
    func stringValue(forKey key: String) -> String {
        guard let value = infoDictionary?[key] as? String
        else {
            fatalError("Error due getting string value for \(key), from infoDictionary")
        }
        return value
    }

    var versionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var fullVersion: String? {
        guard let versionNumber = versionNumber,
              let buildNumber = buildNumber
        else {
            return nil
        }
        return "\(versionNumber) (\(buildNumber))"
    }
}
