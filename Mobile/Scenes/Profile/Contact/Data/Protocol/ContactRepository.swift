//
//  ContactRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 24.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol ContactRepository {
    typealias  ContactInfoHandler = (Result<ContactEntity, ABError>) -> Void
    func getContactInfo(handler: @escaping ContactInfoHandler)
}
