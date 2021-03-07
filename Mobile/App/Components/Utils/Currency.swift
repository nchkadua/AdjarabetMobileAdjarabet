//
//  Currency.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public enum Currency {
    case gel
    case usd
    case eur
    case gbp
    case rub
    case uah
    case amd

    public var description: Description {
        switch self {
        case .gel: return Description(symbol: "₾", abbreviation: "GEL")
        case .usd: return Description(symbol: "$", abbreviation: "USD")
        case .eur: return Description(symbol: "€", abbreviation: "EUR")
        case .gbp: return Description(symbol: "£", abbreviation: "GBP")
        case .rub: return Description(symbol: "₽", abbreviation: "RUB")
        case .uah: return Description(symbol: "₴", abbreviation: "UAH")
        case .amd: return Description(symbol: "֏", abbreviation: "AMD")
        }
    }

    public struct Description {
        public let symbol: String
        public let abbreviation: String
    }
}

// MARK: - currency ID Constructor -- Core API extension
public extension Currency {
    init?(currencyId: Int) {
        switch currencyId {
        case 2: self = .gel
        case 3: self = .usd
        case 4: self = .eur
        case 5: self = .gbp
        case 6: self = .rub
        case 7: self = .uah
        case 8: self = .amd
        default: return nil
        }
    }
}
