//
//  AdjarabetCoreResult.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetCoreResult {
}

public extension AdjarabetCoreResult {
    struct Header {
        public struct Empty: HeaderProtocol {
            public init(headers: [AnyHashable: Any]?) throws { }
        }

        public struct Login: HeaderProtocol {
            public var sessionId = ""
            public let fields: [AnyHashable: Any]

            public init(headers: [AnyHashable: Any]?) {
                self.fields = headers ?? [:]

                let cookie = headers?["Set-Cookie"] as? String ?? ""
                let split = cookie.split(separator: ";")

                if let sessionId = split.first(where: { $0.contains("JSESSIONID=") }) {
                    self.sessionId = String(sessionId)
                }
            }
        }
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {
    func toStringValues() -> [String: String] {
        [String: String](uniqueKeysWithValues: self.compactMap { key, value -> (String, String)? in
            guard let stringKey = key as? String, let stringValue = value as? String else {return nil}
            return (stringKey, stringValue)
        })
    }
}

public extension AdjarabetCoreResult {
    struct Result<C: Codable, H: HeaderProtocol>: HeaderProvidingCodableType {
        public let codable: C
        public let header: H?

        public init(codable: C, header: H?) {
            self.codable = codable
            self.header = header
        }
    }

    typealias Login         = Result<AdjarabetCoreCodable.Authentication.Login, AdjarabetCoreResult.Header.Login>
    typealias Logout        = Result<AdjarabetCoreCodable.Empty, AdjarabetCoreResult.Header.Empty>
    typealias AliveSession  = Result<AdjarabetCoreCodable.AliveSession, AdjarabetCoreResult.Header.Empty>
    typealias Balance       = Result<AdjarabetCoreCodable.Balance, AdjarabetCoreResult.Header.Empty>
    typealias SmsCode       = Result<AdjarabetCoreCodable.Authentication.SmsCode, AdjarabetCoreResult.Header.Empty>
}
