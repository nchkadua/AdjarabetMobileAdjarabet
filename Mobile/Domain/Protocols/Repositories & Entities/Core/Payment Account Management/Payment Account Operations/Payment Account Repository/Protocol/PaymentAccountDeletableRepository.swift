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
     Returns Status Code
     */
    typealias PaymentAccountDeleteHandler = (Result<Int, Error>) -> Void
    func delete(params: PaymentAccountDeleteParams,
                handler: @escaping PaymentAccountDeleteHandler)
}

// for delete
struct PaymentAccountDeleteParams {
    let id: Int64
}
