//
//  PasswordChangeRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/11/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol PasswordChangeRepository {
    typealias PasswordChangeHandler = (Result<PasswordChangeEntity, ABError>) -> Void
    func change(params: PasswordChangeParams, handler: @escaping PasswordChangeHandler)
}

struct PasswordChangeParams {
    let oldPassword: String
    let newPassword: String
    let otp: Int
}
