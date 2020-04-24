//
//  ABUserDefaults.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@propertyWrapper
public struct ABUserDefaults<T> {
    public let key: String
    public let defaultValue: T
    public let userDefaults: UserDefaults

    public init(_ key: String, defaultValue: T) {
        self.init(.standard, key: key, defaultValue: defaultValue)
    }

    public init(_ userDefaults: UserDefaults, key: String, defaultValue: T) {
        self.userDefaults = userDefaults
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            let describing = String(describing: newValue)
            let isOptionalAndNil = describing == "nil" && T.self != String.self

            if isOptionalAndNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}
