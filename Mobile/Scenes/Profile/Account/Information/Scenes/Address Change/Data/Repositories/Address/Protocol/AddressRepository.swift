//
//  AddressRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
protocol AddressRepository: AddressReadableRepository,
                            AddressWritableRepository { }

// MARK: - Readable Repository
protocol AddressReadableRepository { }

// MARK: - Writable Repository
protocol AddressWritableRepository {
    /**
     Changes address of user specified with *params*
     Returns .success if address was changed successfully
     Otherwise returns .failure with error
     */
    typealias ChangeAddressHandler = (Result<Void, ABError>) -> Void
    func changeAddress(with params: ChangeAddressParams,
                       handler: @escaping ChangeAddressHandler)
}

// for changeAddress
struct ChangeAddressParams {
    let address: String
    /*
    let addressLine1: String
    let addressLine2: String
    let addressLine3: String
    let town: String
    let county: String
    let region: String
    let postCode: String
    */
}
