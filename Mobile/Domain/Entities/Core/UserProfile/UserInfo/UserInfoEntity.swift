//
//  UserInfoEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct UserInfoEntity {
    public let userId: Int64? // User ID
    public let name: String? // Name
    public let surname: String? // Surname
    public let middleName: String?
    public let gender: Int? // Gender -> TO ENUM
    public let userName: String? // Username
    public let countryId: Int? // Country -> TO GET
    public let address: String? // Address
    public let birthDate: String? // Birth Date -> TO FORMAT
    public let email: String? // Mail
    public let phone: String? // Phone Number
    public let statusId: Int? // Status -> TO STRING
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
    // Personal ID
    // Password
}
