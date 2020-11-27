//
//  AccountInfoModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct AccountInfoModel {
    public let userName: String
    public let userId: String
    public let personalId: String
    public let status: String
    public let password: String
    public let email: String
    public let phoneNumber: String
    public let name: String
    public let surname: String
    public let birthDate: String
    public let gender: String
    public let country: String
    public let address: String
}

// TODO: format
public extension AccountInfoModel {
    static func create(from e: UserInfoEntity) -> AccountInfoModel {
        AccountInfoModel(
            userName: e.userName ?? "",
            userId: String(e.userId ?? -1),
            personalId: "123***789",
            status: String(e.statusId ?? -1),
            password: "---------",
            email: e.email ?? "",
            phoneNumber: e.phone ?? "",
            name: e.name ?? "",
            surname: e.surname ?? "",
            birthDate: e.birthDate ?? "",
            gender: String(e.gender ?? -1),
            country: String(e.countryId ?? -1),
            address: e.address ?? ""
        )
    }
}
