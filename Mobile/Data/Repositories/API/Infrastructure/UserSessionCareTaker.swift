//
//  UserSessionCareTaker.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
public class UserSessionCareTaker {
    private let storage: KeychainWrapper
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let key: String
    private let accessibility: KeychainItemAccessibility

    public init(
        storage: KeychainWrapper = KeychainContainer.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        key: String = "com.adjarabet.mobile.usersession",
        accessibility: KeychainItemAccessibility = .alwaysThisDeviceOnly) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
        self.key = key
        self.accessibility = accessibility
    }

    public func save(_ memento: UserSession.Memento?) throws {
        if memento == nil {
            storage.removeObject(forKey: key, withAccessibility: accessibility)
        } else {
            let data = try encoder.encode(memento)
            storage.set(data, forKey: key)
        }

        #if DEBUG
            print(memento ?? "")
        #endif
    }

    public func load() throws -> UserSession.Memento {
        guard let data = storage.data(forKey: key),
            let memento = try? decoder.decode(UserSession.Memento.self, from: data) else {
                throw Error.mementoNotFound
        }

        #if DEBUG
            print(memento)
        #endif
        return memento
    }

    public enum Error: String, Swift.Error {
        case mementoNotFound
    }
}
