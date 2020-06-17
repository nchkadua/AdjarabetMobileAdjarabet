//
//  UserAgentProvider.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol UserAgentProvider {
    var userAgent: String { get }
}

public class DefaultUserAgentProvider: UserAgentProvider {
    public var userAgent: String {
        [appNameAndVersion, deviceName, deviceVersion, cfNetworkVersion, darwin].compactMap { $0 }.joined(separator: " ")
    }

    private var darwin: String? {
        var sysinfo = utsname()
        uname(&sysinfo)
        let bytes = Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN))
        guard let darwinVersion = String(bytes: bytes, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters) else {return nil}
        return "Darwin/\(darwinVersion)"
    }

    private var cfNetworkVersion: String? {
        guard let cfNetworkVersion = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary?["CFBundleShortVersionString"] as? String else {return nil}
        return "CFNetwork/\(cfNetworkVersion)"
    }

    private var deviceVersion: String {
        "\(UIDevice.current.systemName)/\(UIDevice.current.systemVersion)"
    }

    private var deviceName: String? {
        var sysinfo = utsname()
        uname(&sysinfo)
        let bytes = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        return String(bytes: bytes, encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)
    }

    private var appNameAndVersion: String? {
        let dictionary = Bundle.main.infoDictionary ?? [:]
        guard let name = dictionary["CFBundleName"] as? String, let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}
        return "\(name)/\(version)"
    }
}
