//
//  PaymentAccountsDocRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentAccountsDocRepository {
    typealias PaymentAccountsDocHandler = (Result<PaymentAccountsDocEntity, ABError>) -> Void
    func getUrl(handler: @escaping PaymentAccountsDocHandler)
}
