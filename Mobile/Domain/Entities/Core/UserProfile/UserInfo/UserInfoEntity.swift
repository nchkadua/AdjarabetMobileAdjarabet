//
//  UserInfoEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct UserInfoEntity {
    public let userId: Int64?
    public let name: String?
    public let surname: String?
    public let middleName: String?
    public let gender: Int? // TODO: enum
    public let userName: String?
    public let countryId: Int? // TODO: get with another service
    public let address: String?
    public let birthDate: String? // TODO: format to Date
    public let email: String?
    public let phone: String?
    public let statusId: Int? // TODO: toString
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
}
