//
//  AmountFormatterUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol AmountFormatterUseCase {
    /**
     Converts Double to Amount form
     */
    func format(_ number: Double) -> String
}

struct DefaultAmountFormatterUseCase: AmountFormatterUseCase {
    @Inject private var userSession: UserSessionReadableServices

    func format(_ number: Double) -> String {
        let number = String(format: "%.2f", number)
        if let currencyId = userSession.currencyId,
           let currency = Currency(currencyId: currencyId) {
            let desc = currency.description
            return "\(desc.symbol) \(number) \(desc.abbreviation)"
        } else {
            return number
        }
    }
}
