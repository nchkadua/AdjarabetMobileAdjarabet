//
//  AdjarabetCoreClient.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class AdjarabetCoreClient {
    public let baseUrl: URL

    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    public var baseUrlComponents: URLComponents {
        URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
    }

    public enum Method: String {
        case login
        case loginOtp
        case balance = "getBalance"
        case smsCode = "getSmsCode"
        case logout
        case aliveSession = "isSessionActive"
        case currentUserInfo = "getUserInfo"
        case transactionHistory = "getUsersTransactions"
        case accessList = "getAccessList"
    }
}
