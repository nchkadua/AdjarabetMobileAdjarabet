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

class DefaultAmountFormatterUseCase: AmountFormatterUseCase {
    @Inject private var userSession: UserSessionReadableServices

    private lazy var formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.groupingSeparator = ","
        f.groupingSize = 3
        f.usesGroupingSeparator = true
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    func format(number: Double, in format: AmountFormatType) -> String {
        if let fnumber = formatter.string(from: .init(value: number)),
           let currencyId = userSession.currencyId,
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
        let defaultValue = String(format: "%.2f", number)
        return defaultValue
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
            if let unumber = formatter.number(from: String(snumber))?.doubleValue {
                return unumber
            }
            return nil
        }
        return nil
    }
}
