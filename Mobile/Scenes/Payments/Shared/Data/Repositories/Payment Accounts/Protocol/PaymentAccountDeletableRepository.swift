//
//  PaymentAccountDeletableRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentAccountDeletableRepository {
    /**
     Deletes payment account specified by payment account ID
     for the currently authenticated user
     */
    typealias PaymentAccountDeleteHandler = (Result<Void, ABError>) -> Void
    func delete(params: PaymentAccountDeleteParams,
                handler: @escaping PaymentAccountDeleteHandler)
}

// delete params
struct PaymentAccountDeleteParams {
    let id: Int64
}
