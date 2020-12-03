//
//  Country.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum Country {
    /* Popular */
    case georgia
    case armenia
    case azerbaijan
    case kazakhstan
    /* A */
    case afghanistan
 // case alandIslands
    case albania
    case algeria
    case americanSamoa
    case andorra
    case angola
    case anguilla
 // case antarctica
    case antiguaAndBarbuda
    case argentia
    case aruba
    case australia
    case austria
    /* B */
    case bahamas
    case bahrain
    case bangladesh
    case barbados
    case belarus
    case belgium
    case belize
    case benin
    case bermuda
    case bhutan
    case bolivia
    case bonaireSintEustatiusAndSaba
    case bosniaAndHerzegovina
    case botswana
 // case bouvetIsland
    case brazil
 // case britishIndianOceanTerritory
    case brunei
    case bulgaria
    case burtkinaFaso
    case burundi
    /* C */
    case cambodia
    case cameroom
    case canada
 // case capeVerde
    case caymanIslands
    case centralAfricanRepublic
    case chad
    case chile
    case china
 // case christmasIsland
 // case cocos
    case colombia
    case coromos
    case congo
    case cookIsland
    case costaRica
    case croatia
    case cuba
    case curacao
    case cyprus
    case czechRepublic
    /* D */
    case democraticRepublicOfTheCongo
    case denmark
    case djibouti
    case dominica
    case dominicanRepublic
    /* E */
    case ecuador
    case egypt
    case elSalvador
    case equatorialGuinea
    case eritrea
    case estonia
    case ethiopia
    /* F */
    case falklandIslands
    case faroeIslands
    case fiji
    case finland
    case france
    case frenchGuiana
    case frenchPolynesia
 // case frenchSouthernTerritories

    case unitedKingdom

    public var description: Description {
        let r = R.string.localization.self
        switch self {
        /* Popular */
        case .georgia:     return Description(r.georgia.localized(), "GEO", "+995", "🇬🇪", "ge")
        case .armenia:     return Description(r.armenia.localized(), "ARM", "+374", "🇦🇲", "hy")
        case .azerbaijan:  return Description(r.azerbaijan.localized(), "AZE", "+994", "🇦🇿")
        case .kazakhstan:  return Description(r.kazakhstan.localized(), "KAZ", "+7", "🇰🇿")
        /* A */
        case .afghanistan:        return Description("", "AFG", "+93", "")
        case .albania:            return Description("", "ALB", "+335", "")
        case .algeria:            return Description("", "DZA", "+213", "")
        case .americanSamoa:      return Description("", "ASM", "+1", "")
        case .andorra:            return Description("", "AND", "+376", "")
        case .angola:             return Description("", "AGO", "+244", "")
        case .anguilla:           return Description("", "AIA", "+1", "")
        case .antiguaAndBarbuda:  return Description("", "ATG", "+1", "")
        case .argentia:           return Description("", "ARG", "+54", "")
        case .aruba:              return Description("", "ABW", "+297", "")
        case .australia:          return Description("", "AUS", "+61", "")
        case .austria:            return Description("", "AUT", "+43", "")
        /* B */
        case .bahamas:                      return Description("", "BHS", "+1", "")
        case .bahrain:                      return Description("", "BHR", "+973", "")
        case .bangladesh:                   return Description("", "BGD", "+880", "")
        case .barbados:                     return Description("", "BRB", "+1", "")
        case .belarus:                      return Description("", "BLR", "+375", "")
        case .belgium:                      return Description("", "BEL", "+32", "")
        case .belize:                       return Description("", "BLZ", "+501", "")
        case .benin:                        return Description("", "NEB", "+229", "")
        case .bermuda:                      return Description("", "BMU", "+1", "")
        case .bhutan:                       return Description("", "BTN", "+975", "")
        case .bolivia:                      return Description("", "BOL", "+591", "")
        case .bonaireSintEustatiusAndSaba:  return Description("", "BES", "+599", "")
        case .bosniaAndHerzegovina:         return Description("", "BIH", "+387", "")
        case .botswana:                     return Description("", "BWA", "+267", "")
        case .brazil:                       return Description("", "BRA", "+55", "")
        case .brunei:                       return Description("", "BRN", "+673", "")
        case .bulgaria:                     return Description("", "BGR", "+359", "")
        case .burtkinaFaso:                 return Description("", "BFA", "+226", "")
        case .burundi:                      return Description("", "BDI", "+257", "")
        /* C */
        case .cambodia:                return Description("", "KHM", "+855", "")
        case .cameroom:                return Description("", "CMR", "+237", "")
        case .canada:                  return Description("", "CAN", "+1", "")
        case .caymanIslands:           return Description("", "CYM", "+1", "")
        case .centralAfricanRepublic:  return Description("", "CAF", "+236", "")
        case .chad:                    return Description("", "TCD", "+235", "")
        case .chile:                   return Description("", "CHL", "+56", "")
        case .china:                   return Description("", "CHN", "+86", "")
        case .colombia:                return Description("", "COL", "+57", "")
        case .coromos:                 return Description("", "COM", "+269", "")
        case .congo:                   return Description("", "COG", "+242", "")
        case .cookIsland:              return Description("", "COK", "+682", "")
        case .costaRica:               return Description("", "CRI", "+506", "")
        case .croatia:                 return Description("", "HRV", "+385", "")
        case .cuba:                    return Description("", "CUB", "+53", "")
        case .curacao:                 return Description("", "CUW", "+599", "")
        case .cyprus:                  return Description("", "CYP", "+357", "")
        case .czechRepublic:           return Description("", "CZE", "+420", "")
        /* D */
        case .democraticRepublicOfTheCongo:  return Description("", "COD", "+243", "")
        case .denmark:                       return Description("", "DNK", "+45", "")
        case .djibouti:                      return Description("", "DJI", "+253", "")
        case .dominica:                      return Description("", "DMA", "+1", "")
        case .dominicanRepublic:             return Description("", "DOM", "+1", "")
        /* E */
        case .ecuador:           return Description("", "ECU", "+593", "")
        case .egypt:             return Description("", "EGY", "+20", "")
        case .elSalvador:        return Description("", "SLV", "+503", "")
        case .equatorialGuinea:  return Description("", "GNQ", "+240", "")
        case .eritrea:           return Description("", "ERI", "+291", "")
        case .estonia:           return Description("", "EST", "+372", "")
        case .ethiopia:          return Description("", "ETH", "+251", "")
        /* F */
        case .falklandIslands:  return Description("", "FLK", "+500", "")
        case .faroeIslands:     return Description("", "FRO", "+298", "")
        case .fiji:             return Description("", "FJI", "+679", "")
        case .finland:          return Description("", "FIN", "+358", "")
        case .france:           return Description("", "FRA", "+33", "")
        case .frenchGuiana:     return Description("", "GUF", "+594", "")
        case .frenchPolynesia:  return Description("", "PYF", "+689", "")

        case .unitedKingdom:  return Description("United Kingdom", "GBR", "+44", "🇬🇧", "en")
        }
    }

    public struct Description {
        public let name: String
        public let alpha3Code: String
        public let phonePrefix: String
        public let stringFlag: String?
        public let localizableIdentifier: String?

        public init(
            _ name: String,
            _ alpha3Code: String,
            _ phonePrefix: String,
            _ stringFlag: String? = nil,
            _ localizableIdentifier: String? = nil) {
            self.name = name
            self.alpha3Code = alpha3Code
            self.stringFlag = stringFlag
            self.phonePrefix = phonePrefix
            self.localizableIdentifier = localizableIdentifier
        }
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
