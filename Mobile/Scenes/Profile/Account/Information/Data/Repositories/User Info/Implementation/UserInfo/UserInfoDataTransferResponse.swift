//
//  UserInfoDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

struct UserInfoDataTransferResponse: CoreDataTransferResponse {
    /*
    struct Header: HeaderProtocol {
        init(headers: [AnyHashable: Any]?) throws {
            ...
        }
    }
    */
    struct Body: CoreStatusCodeable {
        let statusCode: Int
        let userId: Int64?
        let name: String?
        let surname: String?
        let middleName: String?
        let gender: String?
        let userName: String?
        let countryId: Int?
        let address: String?
        let birthDate: String?
        let email: String?
        let tel: String?
        let statusId: Int?
		let suspendTill: String?
        /*
        let isOtpOn: Bool?
        let hasClubCard: Bool?
        let language: String?
        let telephoneCode: String?
        let dateRegistered: String?
        let activeNotifications: Int64?
        let preferredCurrencyID: Int?
        let verifiedContactChannel: Int?
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
            case address = "Address"
            case birthDate = "BirthDate"
            case email = "Email"
            case tel = "Tel"
            case statusId = "StatusID"
			case suspendTill = "SuspendTill"
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

    typealias Entity = UserInfoEntity

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(.init(
            userId: body.userId,
            name: body.name,
            surname: body.surname,
            middleName: body.middleName,
            gender: body.gender != nil ? Gender(genderId: body.gender!) : nil,
            userName: body.userName,
            country: body.countryId != nil ? Country(countryId: body.countryId!) : nil,
            address: body.address,
            birthDate: body.birthDate,
            email: body.email,
            phone: body.tel,
			statusId: body.statusId,
			suspendTill: body.suspendTill
			)
		)
    }
}
