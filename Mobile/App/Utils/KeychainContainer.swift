//
//  KeychainContainer.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation
import SharedFramework

public class KeychainContainer {
    public static let defaultKeychainGroup = "RDJN6C84H4.com.adjarabet.Mobile.credentials"
    public static let shared = KeychainWrapper(serviceName: defaultKeychainGroup, accessGroup: nil)
}
