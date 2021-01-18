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
        case .gel: return Description(stringValue: "₾")
        case .usd: return Description(stringValue: "$")
        case .eur: return Description(stringValue: "€")
        case .gbp: return Description(stringValue: "£")
        case .rub: return Description(stringValue: "₽")
        case .uah: return Description(stringValue: "₴")
        case .amd: return Description(stringValue: "֏")
        }
    }

    public struct Description {
        public let stringValue: String
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
