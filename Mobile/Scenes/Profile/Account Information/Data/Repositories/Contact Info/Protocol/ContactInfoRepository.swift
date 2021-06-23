//
//  ContactInfoRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol ContactInfoRepository: ContactInfoReadableRepository,
                                ContactInfoWritableRepository { }

protocol ContactInfoReadableRepository { }

protocol ContactInfoWritableRepository {
    /**
     Updates users' contact information
     Caller can specify only this contact information
     which it wants to update
     For example only *tel* or *email* or both
     */
    typealias UpdateContactInfoHandler = (Result<Void, ABError>) -> Void
    func updateContactInfo(with params: UpdateContactInfoParams,
                           handler: @escaping UpdateContactInfoHandler)
}

struct UpdateContactInfoParams {
    let pass: String       // users' password
    let otp: String?       // if high security is enabled
    let email: String?     // for updating e-mail
    let tel: String?       // for updating tel
    let newTelOtp: String?
}
