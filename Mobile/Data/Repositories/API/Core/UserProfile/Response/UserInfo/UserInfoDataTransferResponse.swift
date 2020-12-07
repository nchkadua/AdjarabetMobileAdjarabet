//
//  UserInfoDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class UserInfoDataTransferResponse: DataTransferResponse {
    /*
    public struct Header: HeaderProtocol {
        public init(headers: [AnyHashable: Any]?) throws {
            ...
        }
    }
    */
    public struct Body: Codable {
        public let statusCode: Int?
        public let userId: Int64?
        public let name: String?
        public let surname: String?
        public let middleName: String?
        public let gender: Int?
        public let userName: String?
        public let countryId: Int?
        // public let address: String? // FIXME: add real address
        public let birthDate: String?
        public let email: String?
        public let tel: String?
        public let statusId: Int?
        /*
        public let isOtpOn: Bool?
        public let hasClubCard: Bool?
        public let language: String?
        public let telephoneCode: String?
        public let dateRegistered: String?
        public let activeNotifications: Int64?
        public let preferredCurrencyID: Int?
        public let verifiedContactChannel: Int?
        */

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case userId = "UserID"
            case name = "Name"
            case surname = "Surname"
            case middleName = "MiddleName"
            case gender = "Gender"
            case userName = "UserName"
            case countryId = "CountryID"
            // case address = "Address" // FIXME: add real address
            case birthDate = "BirthDate"
            case email = "Email"
            case tel = "Tel"
            case statusId = "StatusID"
            /*
            case isOtpOn = "IsOTPOn"
            case hasClubCard = "HasClubCard"
            case language = "Language"
            case telephoneCode = "TelephoneCode"
            case dateRegistered = "DateRegistered"
            case activeNotifications = "ActiveNotifications"
            case preferredCurrencyID = "PreferredCurrencyID"
            case verifiedContactChannel = "VerifiedContactChannel"
            */
        }
    }

    public typealias Entity = UserInfoEntity

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity {
        UserInfoEntity(
            userId: body.userId,
            name: body.name,
            surname: body.surname,
            middleName: body.middleName,
            gender: body.gender != nil ? Gender(genderId: body.gender!) : nil,
            userName: body.userName,
            country: body.countryId != nil ? Country(countryId: body.countryId!) : nil,
            address: "", // body.address, // FIXME: add real address
            birthDate: body.birthDate,
            email: body.email,
            phone: body.tel,
            statusId: body.statusId
        )
    }
}
