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
    func format(number: Double, in format: AmountFormatType) -> String
    /**
     Unformats converted Amount back to the Double
     */
    func unformat(number: String, from format: AmountFormatType) -> Double?
}

enum AmountFormatType {
    // swiftlint:disable identifier_name
    case s_n_a // -> "${SYMBOL} ${NUMBER} ${ABBREVIATION}"
    case sn_a  // -> "${SYMBOL}${NUMBER} ${ABBREVIATION}"
    case sn    // -> "${SYMBOL}${NUMBER}"
    // swiftlint:enable identifier_name
}

struct DefaultAmountFormatterUseCase: AmountFormatterUseCase {
    @Inject private var userSession: UserSessionReadableServices

    func format(number: Double, in format: AmountFormatType) -> String {
        // format number
        let fnumber = String(format: "%.2f", number)
        if let currencyId = userSession.currencyId,
           let currency = Currency(currencyId: currencyId) {
            // d = description
            let d = currency.description
            /* format */
            switch format {
            case .s_n_a: return "\(d.symbol) \(fnumber) \(d.abbreviation)"
            case .sn_a:  return "\(d.symbol)\(fnumber) \(d.abbreviation)"
            case .sn:    return "\(d.symbol)\(fnumber)"
            }
        }
        return fnumber
    }

    func unformat(number: String, from format: AmountFormatType) -> Double? {
        if let unumber = Double(number) {
            return unumber
        }
        if let currencyId = userSession.currencyId,
           let currency = Currency(currencyId: currencyId) {
            // d = description
            let d = currency.description
            /* unformat */
            let snumber: Substring
            switch format {
            case .s_n_a:
                guard number.count > d.symbol.count + d.abbreviation.count + 2
                else { return nil }
                let start = number.index(number.startIndex, offsetBy: d.symbol.count + 1)
                let end = number.index(number.endIndex, offsetBy: -d.abbreviation.count - 2)
                let range = start..<end
                snumber = number[range]
            case .sn_a:
                guard number.count > d.symbol.count + d.abbreviation.count + 1
                else { return nil }
                let start = number.index(number.startIndex, offsetBy: d.symbol.count)
                let end = number.index(number.endIndex, offsetBy: -d.abbreviation.count - 2)
                let range = start..<end
                snumber = number[range]
            case .sn:
                guard number.count > d.symbol.count
                else { return nil }
                let start = number.index(number.startIndex, offsetBy: d.symbol.count)
                snumber = number[start...]
            }
            if let unumber = Double(snumber) {
                return unumber
            }
            return nil
        }
        return nil
    }
}
