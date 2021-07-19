//
//  CoreApiAddressRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiAddressRepository: CoreApiRepository { }

extension CoreApiAddressRepository: AddressRepository {
    func changeAddress(with params: ChangeAddressParams,
                       handler: @escaping ChangeAddressHandler) {
        performTask(expecting: CoreApiStatusCodeDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "changeAddress")
                .setBody(key: "address", value: params.address)
                /*
                .setBody(key: "AddressLine1", value: params.addressLine1)
                .setBody(key: "AddressLine2", value: params.addressLine2)
                .setBody(key: "AddressLine3", value: params.addressLine3)
                .setBody(key: "Town", value: params.town)
                .setBody(key: "County", value: params.county)
                .setBody(key: "Region", value: params.region)
                .setBody(key: "PostCode", value: params.postCode)
                */
        }
    }
}
