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

public extension AccountInfoModel {
    static func create(from e: UserInfoEntity) -> AccountInfoModel {
        AccountInfoModel(
            userName: e.userName ?? "",
            userId: e.userId == nil ? "" : String(e.userId!),
            personalId: "123***789", // TODO: add in entity
            status: e.statusId == nil ? "" : String(e.statusId!), // TODO: e.statusId -> String
            password: String.passwordRepresentation,
            email: e.email ?? "",
            phoneNumber: e.phone ?? "",
            name: e.name ?? "",
            surname: e.surname ?? "",
            birthDate: e.birthDate ?? "",
            gender: e.gender?.description.stringValue ?? "",
            country: e.country?.description.name ?? "",
            address: e.address ?? ""
        )
    }
}
