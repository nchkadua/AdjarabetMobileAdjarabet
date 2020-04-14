//
//  AdjarabetCoreCodable.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetCoreCodable {
}

public extension AdjarabetCoreCodable {
    struct Empty: Codable {
    }

    struct StatusCodeChecker: Codable {
        public let code: AdjarabetCoreStatusCode

        public var isSuccess: Bool {
            code == .STATUS_SUCCESS
        }

        enum CodingKeys: String, CodingKey {
            case code = "StatusCode"
        }
    }

    struct Authentication {
        public struct SmsCode: Codable {
            public let statusCode: AdjarabetCoreStatusCode

            enum CodingKeys: String, CodingKey {
                case statusCode = "StatusCode"
            }
        }

        public struct Login: Codable {
               public let isLoggedOn: Bool
               public let isOTPRequired: Bool
               public let userID: Int
               public let username: String
               public let errorCode: Int?
               public let userStatusID: Int
               public let language: String
               public let isUserSuspended: Bool
               public let isUserExcluded: Bool
               public let preferredCurrency: Int?
               public let sessionExpirationDate: String?
               public let realityCheckDueDate: String?

               enum CodingKeys: String, CodingKey {
                   case isLoggedOn = "IsLoggedOn"
                   case isOTPRequired = "IsOTPRequired"
                   case userID = "UserID"
                   case username = "UserName"
                   case errorCode = "ErrorCode"
                   case userStatusID = "UserStatusID"
                   case language = "Language"
                   case isUserSuspended = "IsUserSuspended"
                   case isUserExcluded = "IsUserExcluded"
                   case preferredCurrency = "PreferredCurrency"
                   case sessionExpirationDate = "SessionExpirationDate"
                   case realityCheckDueDate = "RealityCheckDueDate"
               }
           }
    }

    struct AliveSession: Codable {
    }

//    struct ActiveSession: Codable {
//        let userID: Int
//        let lastLoginTime, expirationDate, realityCheckDueDate: String?
//        let lastAccessIP: String?
//
//        enum CodingKeys: String, CodingKey {
//            case userID = "UserID"
//            case lastLoginTime = "LastLoginTime"
//            case expirationDate = "ExpirationDate"
//            case realityCheckDueDate = "RealityCheckDueDate"
//            case lastAccessIP = "LastAccessIP"
//        }
//    }

    struct Balance: Codable {
        public let currencyID: Int
        public let balanceAmount: Double
        public let lockedAmount: Double?
        public let bonusAmount: Double?

        enum CodingKeys: String, CodingKey {
            case currencyID = "CurrencyID"
            case balanceAmount = "BalanceAmount"
            case lockedAmount = "LockedAmount"
            case bonusAmount = "BonusAmount"
        }
    }
}
