//
//  Country.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum Country {
    case georgia
    case armenia
    case unitedKingdom

    public var description: Description {
        switch self {
        case .georgia: return Description(
            name: "Georgia",
            alpha3Code: "GEO",
            stringFlag: "🇬🇪",
            phonePrefix: "+995",
            localizableIdentifier: "ge"
        )
        case .armenia: return Description(
            name: "Armenia",
            alpha3Code: "ARM",
            stringFlag: "🇦🇲",
            phonePrefix: "+374",
            localizableIdentifier: "hy"
        )
        case .unitedKingdom: return Description(
            name: "United Kingdom",
            alpha3Code: "GBR",
            stringFlag: "🇬🇧",
            phonePrefix: "+44",
            localizableIdentifier: "en"
        )
        }
    }

    public struct Description {
        public let name: String
        public let alpha3Code: String
        public let stringFlag: String
        public let phonePrefix: String
        public let localizableIdentifier: String
    }
}

// MARK: - CaseIterable
extension Country: CaseIterable { }

// MARK: - Localizable Identifier Constructor
public extension Country {
    init?(localizableIdentifier: String) {
        if let country = Country.allCases.first(where: { $0.description.localizableIdentifier == localizableIdentifier }) {
            self = country
        } else {
            return nil
        }
    }
}

// MARK: - country ID Constructor -- Core API extension
public extension Country {
    init?(countryId: Int) {
        switch countryId {
        case 7:   self = .georgia
        case 519: self = .armenia
        case 741: self = .unitedKingdom
        default:  return nil
        }
    }
}

// MARK: Representable title
public extension Country.Description {
    var title: String {
        ("\(stringFlag) \(alpha3Code) \(phonePrefix)")
    }
}
