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
    }
}

public extension HeaderProvidingCodableType {
    static func validate(data: Data) throws {
        let statusCode = try JSONDecoder().decode(AdjarabetCoreCodable.StatusCodeChecker.self, from: data)

        if !statusCode.isSuccess {
            throw AdjarabetCoreClientError.invalidStatusCode(code: statusCode.code)
        }
    }
}
