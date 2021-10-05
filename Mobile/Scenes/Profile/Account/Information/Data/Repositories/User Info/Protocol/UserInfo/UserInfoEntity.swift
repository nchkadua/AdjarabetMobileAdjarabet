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
    public let gender: Gender?
    public let userName: String?
    public let country: Country?
    public let address: String?
    public let birthDate: String? // TODO: format to Date
    public let email: String?
    public let phone: String?
    public let statusId: Int? // TODO: change with enum
	public let suspendTill: String?
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
