//
//  Country.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum Country {
    case georgia // Popular
    case armenia
    case azerbaijan
    case kazakhstan
    case afghanistan // A
 // case alandIslands
    case albania
    case algeria
    case americanSamoa
    case andorra
    case angola
    case anguilla
 // case antarctica
    case antiguaAndBarbuda
    case argentina // next should be armenia
    case aruba
    case australia
    case austria // next should be azerbaijan
    case bahamas // B
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
    case bonaireSintEustatiusAndSaba // flag
    case bosniaAndHerzegovina
    case botswana
 // case bouvetIsland
    case brazil
 // case britishIndianOceanTerritory
    case brunei
    case bulgaria
    case burtkinaFaso
    case burundi
    case cambodia // C
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
    case democraticRepublicOfTheCongo // D
    case denmark
    case djibouti
    case dominica
    case dominicanRepublic
    case ecuador // E
    case egypt
    case elSalvador
    case equatorialGuinea
    case eritrea
    case estonia
    case ethiopia
    case falklandIslands // F
    case faroeIslands
    case fiji
    case finland
    case france
    case frenchGuiana
    case frenchPolynesia
 // case frenchSouthernTerritories
    case gabon // G
    case gambia // next should be georgia
    case germany
    case ghana
    case gibraltar
    case greece
    case greenland
    case grenada
    case guadaloupe
    case guam
    case guatemala
 // case guernsey
    case guinea
    case guineaBissau
    case guyana
    case haiti // H
 // case heardIslandAndMcDonaldIslands
    case honduras
    case hongKong
    case hungary
    case iceland // I
    case india
    case indonesia
    case iran
    case iraq
    case ireland
 // case isleOfMand
    case israel
    case italy
    case jamaica // J
    case japan
 // case jersey
    case jordan // next should be kazakhstan
    case kenya // K
    case kiribati
 // case kosovo
    case kuwait
    case kyrgyzstan
    case laos // L
    case latvia
    case lebanon
    case lesotho
    case liberia
    case libya
    case liechtenstein
    case lithuania
    case luxembourg
    case macao // M
    case macedonia
    case madagascar
    case malawi
    case malaysia
    case maldives
    case mali
    case malta
    case marshallIslands
    case mantinique
    case mauritania
    case mauritius
 // case mayotte
    case mexico
    case micronesia
    case moldava
    case monaco
    case mongolia
    case montenegro
    case montserrat
    case morocco
    case mozambique
    case myanmar
    case namibia // N
    case nauru
    case nepal
    case netherlands
    case newCaledonia
    case newZealand
    case nicaragua
    case niger
    case nigeria
    case niue
 // case norfolkIsland
 // case northKorea
    case northernMarianaIslands
    case norway
    case oman // O
    case pakistan // in the bag // P
    case palau
 // case palestine
    case panama
    case papuaNewGuinea
    case paraguay
    case peru
    case phillipines
 // case pitcairn
    case poland
    case puertoRico
    case qatar // Q
 // case reunion // R
    case romania
    case russia
    case rwanda
 // case saintBarthelemy // S
 // case saintHelena
    case saintKittsAndNevis
    case saintLucia
 // case saintMartin
    case saintPierreAndMiquelon
    case saintVincentAndTheGrenadines
    case samoa
    case sanMarino
    case saoTomeAndPrincipe
    case saudiArabia
    case senegal
    case serbia
    case seychelles
    case sierraLeone
    case singapore
    case sintMaarten
    case slovakia
    case slovenia
    case solomonIslands
    case somalia
    case southAfrica
 // case southGeorgiaAndTheSouthSandwichIslands
 // case southKorea
    case southSudan
    case spain
    case sriLanka
    case sudan
    case suriname
 // case svalbardAndJanMayen
 // case swaziland
    case sweden
    case switzerland
    case syria
    case taiwan // T
    case tajikistan
    case tanzania
    case thailand
    case timorLeste
    case togo
    case tokelau
    case tonga
    case trinidadAndTobago
    case tunisia
    case turkey
    case turkmenistan
    case turksAndCaicosIslands
    case tulavu
    case uganda // U
    case ukraine
    case unitedArabEmirates
    case unitedKingdom
    case unitedStates
 // case unitedStatesMinorOutlyingIslands
    case uruguay
    case uzbekistan
    case vanuatu // V
 // case vaticanCity
    case venezuela
    case vietnam
    case virginIslandsBritish
    case virginIslandsUS
    case wallisAndFutuna // W
 // case westernSahara
    case yemen // Y
    case zambia // Z
    case zimbabwe

    public var description: Description {
        let r = R.string.localization.self
        switch self {
        /* Popular */
        case .georgia:     return Description(r.georgia.localized(), "GEO", "+995", "🇬🇪", "ge")
        case .armenia:     return Description(r.armenia.localized(), "ARM", "+374", "🇦🇲", "hy")
        case .azerbaijan:  return Description(r.azerbaijan.localized(), "AZE", "+994", "🇦🇿")
        case .kazakhstan:  return Description(r.kazakhstan.localized(), "KAZ", "+7", "🇰🇿")
        /* A */
        case .afghanistan:        return Description("", "AFG", "+93", "🇦🇫")
        case .albania:            return Description("", "ALB", "+335", "🇦🇱")
        case .algeria:            return Description("", "DZA", "+213", "🇩🇿")
        case .americanSamoa:      return Description("", "ASM", "+1", "🇦🇸")
        case .andorra:            return Description("", "AND", "+376", "🇦🇩")
        case .angola:             return Description("", "AGO", "+244", "🇦🇴")
        case .anguilla:           return Description("", "AIA", "+1", "🇦🇮")
        case .antiguaAndBarbuda:  return Description("", "ATG", "+1", "🇦🇬")
        case .argentina:          return Description("", "ARG", "+54", "🇦🇷")
        case .aruba:              return Description("", "ABW", "+297", "🇦🇼")
        case .australia:          return Description("", "AUS", "+61", "🇦🇺")
        case .austria:            return Description("", "AUT", "+43", "🇦🇹")
        /* B */
        case .bahamas:                      return Description("", "BHS", "+1", "🇧🇸")
        case .bahrain:                      return Description("", "BHR", "+973", "🇧🇭")
        case .bangladesh:                   return Description("", "BGD", "+880", "🇧🇩")
        case .barbados:                     return Description("", "BRB", "+1", "🇧🇧")
        case .belarus:                      return Description("", "BLR", "+375", "🇧🇾")
        case .belgium:                      return Description("", "BEL", "+32", "🇧🇪")
        case .belize:                       return Description("", "BLZ", "+501", "🇧🇿")
        case .benin:                        return Description("", "NEB", "+229", "🇧🇯")
        case .bermuda:                      return Description("", "BMU", "+1", "🇧🇲")
        case .bhutan:                       return Description("", "BTN", "+975", "🇧🇹")
        case .bolivia:                      return Description("", "BOL", "+591", "🇧🇴")
        case .bonaireSintEustatiusAndSaba:  return Description("", "BES", "+599")
        case .bosniaAndHerzegovina:         return Description("", "BIH", "+387", "🇧🇦")
        case .botswana:                     return Description("", "BWA", "+267", "🇧🇼")
        case .brazil:                       return Description("", "BRA", "+55", "🇧🇷")
        case .brunei:                       return Description("", "BRN", "+673", "🇧🇳")
        case .bulgaria:                     return Description("", "BGR", "+359", "🇧🇬")
        case .burtkinaFaso:                 return Description("", "BFA", "+226", "🇧🇫")
        case .burundi:                      return Description("", "BDI", "+257", "🇧🇮")
        /* C */
        case .cambodia:                return Description("", "KHM", "+855", "🇰🇭")
        case .cameroom:                return Description("", "CMR", "+237", "🇨🇲")
        case .canada:                  return Description("", "CAN", "+1", "🇨🇦")
        case .caymanIslands:           return Description("", "CYM", "+1", "🇰🇾")
        case .centralAfricanRepublic:  return Description("", "CAF", "+236", "🇨🇫")
        case .chad:                    return Description("", "TCD", "+235", "🇹🇩")
        case .chile:                   return Description("", "CHL", "+56", "🇨🇱")
        case .china:                   return Description("", "CHN", "+86", "🇨🇳")
        case .colombia:                return Description("", "COL", "+57", "🇨🇴")
        case .coromos:                 return Description("", "COM", "+269", "🇰🇲")
        case .congo:                   return Description("", "COG", "+242", "🇨🇬")
        case .cookIsland:              return Description("", "COK", "+682", "🇨🇰")
        case .costaRica:               return Description("", "CRI", "+506", "🇨🇷")
        case .croatia:                 return Description("", "HRV", "+385", "🇭🇷")
        case .cuba:                    return Description("", "CUB", "+53", "🇨🇺")
        case .curacao:                 return Description("", "CUW", "+599", "🇨🇼")
        case .cyprus:                  return Description("", "CYP", "+357", "🇨🇾")
        case .czechRepublic:           return Description("", "CZE", "+420", "🇨🇿")
        /* D */
        case .democraticRepublicOfTheCongo:  return Description("", "COD", "+243", "🇨🇩")
        case .denmark:                       return Description("", "DNK", "+45", "🇩🇰")
        case .djibouti:                      return Description("", "DJI", "+253", "🇩🇯")
        case .dominica:                      return Description("", "DMA", "+1", "🇩🇲")
        case .dominicanRepublic:             return Description("", "DOM", "+1", "🇩🇴")
        /* E */
        case .ecuador:           return Description("", "ECU", "+593", "🇪🇨")
        case .egypt:             return Description("", "EGY", "+20", "🇪🇬")
        case .elSalvador:        return Description("", "SLV", "+503", "🇸🇻")
        case .equatorialGuinea:  return Description("", "GNQ", "+240", "🇬🇶")
        case .eritrea:           return Description("", "ERI", "+291", "🇪🇷")
        case .estonia:           return Description("", "EST", "+372", "🇪🇪")
        case .ethiopia:          return Description("", "ETH", "+251", "🇪🇹")
        /* F */
        case .falklandIslands:  return Description("", "FLK", "+500", "🇫🇰")
        case .faroeIslands:     return Description("", "FRO", "+298", "🇫🇴")
        case .fiji:             return Description("", "FJI", "+679", "🇫🇯")
        case .finland:          return Description("", "FIN", "+358", "🇫🇮")
        case .france:           return Description("", "FRA", "+33", "🇫🇷")
        case .frenchGuiana:     return Description("", "GUF", "+594", "🇬🇫")
        case .frenchPolynesia:  return Description("", "PYF", "+689", "🇵🇫")
        /* G */
        case .gabon:         return Description("", "GAB", "+241", "🇬🇦")
        case .gambia:        return Description("", "GMB", "+220", "🇬🇲")
        case .germany:       return Description("", "DEU", "+49", "🇩🇪")
        case .ghana:         return Description("", "GHA", "+233", "🇬🇭")
        case .gibraltar:     return Description("", "GIB", "+350", "🇬🇮")
        case .greece:        return Description("", "GRC", "+30", "🇬🇷")
        case .greenland:     return Description("", "GRL", "+299", "🇬🇱")
        case .grenada:       return Description("", "GRD", "+1", "🇬🇩")
        case .guadaloupe:    return Description("", "GLP", "+590", "🇬🇵")
        case .guam:          return Description("", "GUM", "+1", "🇬🇺")
        case .guatemala:     return Description("", "GTM", "+502", "🇬🇹")
        case .guinea:        return Description("", "GIN", "+224", "🇬🇳")
        case .guineaBissau:  return Description("", "GNB", "+245", "🇬🇼")
        case .guyana:        return Description("", "GUY", "+592", "🇬🇾")
        /* H */
        case .haiti:     return Description("", "HTI", "+509", "🇭🇹")
        case .honduras:  return Description("", "HND", "+504", "🇭🇳")
        case .hongKong:  return Description("", "HKG", "+852", "🇭🇰")
        case .hungary:   return Description("", "HUN", "+36", "🇭🇺")
        /* I */
        case .iceland:    return Description("", "ISL", "+354", "🇮🇸")
        case .india:      return Description("", "IND", "+91", "🇮🇳")
        case .indonesia:  return Description("", "IDN", "+62", "🇮🇩")
        case .iran:       return Description("", "IRN", "+98", "🇮🇷")
        case .iraq:       return Description("", "IRQ", "+964", "🇮🇶")
        case .ireland:    return Description("", "IRL", "+353", "🇮🇪")
        case .israel:     return Description("", "ISR", "+972", "🇮🇱")
        case .italy:      return Description("", "ITA", "+39", "🇮🇹")
        /* J */
        case .jamaica:  return Description("", "JAM", "+1", "🇯🇲")
        case .japan:    return Description("", "JPN", "+81", "🇯🇵")
        case .jordan:   return Description("", "JOR", "+962", "🇯🇴")
        /* K */
        case .kenya:       return Description("", "KEN", "+254", "🇰🇪")
        case .kiribati:    return Description("", "KIR", "+686", "🇰🇮")
        case .kuwait:      return Description("", "KWT", "+965", "🇰🇼")
        case .kyrgyzstan:  return Description("", "KGZ", "+996", "🇰🇬")
        /* L */
        case .laos:           return Description("", "LAO", "+856", "🇱🇦")
        case .latvia:         return Description("", "LVA", "+371", "🇱🇻")
        case .lebanon:        return Description("", "LBN", "+961", "🇱🇧")
        case .lesotho:        return Description("", "LSO", "+266", "🇱🇸")
        case .liberia:        return Description("", "LBR", "+231", "🇱🇷")
        case .libya:          return Description("", "LBY", "+218", "🇱🇾")
        case .liechtenstein:  return Description("", "LIE", "+423", "🇱🇮")
        case .lithuania:      return Description("", "LTU", "+370", "🇱🇹")
        case .luxembourg:     return Description("", "LUX", "+352", "🇱🇺")
        /* M */
        case .macao:            return Description("", "MAC", "+853", "🇲🇴")
        case .macedonia:        return Description("", "MKD", "+389", "🇲🇰")
        case .madagascar:       return Description("", "MDG", "+261", "🇲🇬")
        case .malawi:           return Description("", "MWI", "+265", "🇲🇼")
        case .malaysia:         return Description("", "MYS", "+60", "🇲🇾")
        case .maldives:         return Description("", "MDV", "+960", "🇲🇻")
        case .mali:             return Description("", "MLI", "+223", "🇲🇱")
        case .malta:            return Description("", "MLT", "+356", "🇲🇹")
        case .marshallIslands:  return Description("", "MHL", "+692", "🇲🇭")
        case .mantinique:       return Description("", "MTQ", "+596", "🇲🇶")
        case .mauritania:       return Description("", "MRT", "+222", "🇲🇷")
        case .mauritius:        return Description("", "MUS", "+230", "🇲🇺")
        case .mexico:           return Description("", "MEX", "+52", "🇲🇽")
        case .micronesia:       return Description("", "FSM", "+691", "🇫🇲")
        case .moldava:          return Description("", "MDA", "+373", "🇲🇩")
        case .monaco:           return Description("", "MCO", "+377", "🇲🇨")
        case .mongolia:         return Description("", "MNG", "+976", "🇲🇳")
        case .montenegro:       return Description("", "MNE", "+382", "🇲🇪")
        case .montserrat:       return Description("", "MSR", "+1", "🇲🇸")
        case .morocco:          return Description("", "MAR", "+212", "🇲🇦")
        case .mozambique:       return Description("", "MOZ", "+258", "🇲🇿")
        case .myanmar:          return Description("", "MMR", "+95", "🇲🇲")
        /* N */
        case .namibia:                 return Description("", "NAM", "+264", "🇳🇦")
        case .nauru:                   return Description("", "NRU", "+674", "🇳🇷")
        case .nepal:                   return Description("", "NPL", "+977", "🇳🇵")
        case .netherlands:             return Description("", "NLD", "+31", "🇳🇱")
        case .newCaledonia:            return Description("", "NCL", "+687", "🇳🇨")
        case .newZealand:              return Description("", "NZL", "+64", "🇳🇿")
        case .nicaragua:               return Description("", "NIC", "+505", "🇳🇮")
        case .niger:                   return Description("", "NER", "+227", "🇳🇪")
        case .nigeria:                 return Description("", "NGA", "+234", "🇳🇬")
        case .niue:                    return Description("", "NIU", "+683", "🇳🇺")
        case .northernMarianaIslands:  return Description("", "MNP", "+1", "🇲🇵")
        case .norway:                  return Description("", "NOR", "+47", "🇳🇴")
        /* O */
        case .oman:  return Description("", "OMN", "+968", "🇴🇲")
        /* P */
        case .pakistan:        return Description("", "PAK", "+92", "🇵🇰")
        case .palau:           return Description("", "PLW", "+680", "🇵🇼")
        case .panama:          return Description("", "PAN", "+507", "🇵🇦")
        case .papuaNewGuinea:  return Description("", "PNG", "+675", "🇵🇬")
        case .paraguay:        return Description("", "PRY", "+595", "🇵🇾")
        case .peru:            return Description("", "PER", "+51", "🇵🇪")
        case .phillipines:     return Description("", "PHL", "+63", "🇵🇭")
        case .poland:          return Description("", "POL", "+48", "🇵🇱")
        case .puertoRico:      return Description("", "PRI", "+1", "🇵🇷")
        /* Q */
        case .qatar:  return Description("", "QAT", "+974", "🇶🇦")
        /* R */
        case .romania:  return Description("", "ROU", "+40", "🇷🇴")
        case .russia:   return Description("", "RUS", "+7", "🇷🇺")
        case .rwanda:   return Description("", "RWA", "+250", "🇷🇼")
        /* S */
        case .saintKittsAndNevis:            return Description("", "KNA", "+1", "🇰🇳")
        case .saintLucia:                    return Description("", "LCA", "+1", "🇱🇨")
        case .saintPierreAndMiquelon:        return Description("", "SPM", "+508", "🇵🇲")
        case .saintVincentAndTheGrenadines:  return Description("", "VCT", "+1", "🇻🇨")
        case .samoa:                         return Description("", "WSM", "+685", "🇼🇸")
        case .sanMarino:                     return Description("", "SMR", "+378", "🇸🇲")
        case .saoTomeAndPrincipe:            return Description("", "STP", "+239", "🇸🇹")
        case .saudiArabia:                   return Description("", "SAU", "+966", "🇸🇦")
        case .senegal:                       return Description("", "SEN", "+221", "🇸🇳")
        case .serbia:                        return Description("", "SRB", "+381", "🇷🇸")
        case .seychelles:                    return Description("", "SYC", "+248", "🇸🇨")
        case .sierraLeone:                   return Description("", "SLE", "+232", "🇸🇱")
        case .singapore:                     return Description("", "SGP", "+65", "🇸🇬")
        case .sintMaarten:                   return Description("", "SXM", "+1", "🇸🇽")
        case .slovakia:                      return Description("", "SVK", "+421", "🇸🇰")
        case .slovenia:                      return Description("", "SVN", "+386", "🇸🇮")
        case .solomonIslands:                return Description("", "SLB", "+677", "🇸🇧")
        case .somalia:                       return Description("", "SOM", "+252", "🇸🇴")
        case .southAfrica:                   return Description("", "ZAF", "+27", "🇿🇦")
        case .southSudan:                    return Description("", "SSD", "+211", "🇸🇸")
        case .spain:                         return Description("", "ESP", "+34", "🇪🇸")
        case .sriLanka:                      return Description("", "LKA", "+94", "🇱🇰")
        case .sudan:                         return Description("", "SDN", "+249", "🇸🇩")
        case .suriname:                      return Description("", "SUR", "+597", "🇸🇷")
        case .sweden:                        return Description("", "SWE", "+46", "🇸🇪")
        case .switzerland:                   return Description("", "CHE", "+41", "🇨🇭")
        case .syria:                         return Description("", "SYR", "+963", "🇸🇾")
        /* T */
        case .taiwan:                 return Description("", "TWN", "+886", "🇹🇼")
        case .tajikistan:             return Description("", "TJK", "+992", "🇹🇯")
        case .tanzania:               return Description("", "TZA", "+255", "🇹🇿")
        case .thailand:               return Description("", "THA", "+66", "🇹🇭")
        case .timorLeste:             return Description("", "TLS", "+670", "🇹🇱")
        case .togo:                   return Description("", "TGO", "+228", "🇹🇬")
        case .tokelau:                return Description("", "TKL", "+690", "🇹🇰")
        case .tonga:                  return Description("", "TON", "+676", "🇹🇴")
        case .trinidadAndTobago:      return Description("", "TTO", "+1", "🇹🇹")
        case .tunisia:                return Description("", "TUN", "+216", "🇹🇳")
        case .turkey:                 return Description("", "TUR", "+90", "🇹🇷")
        case .turkmenistan:           return Description("", "TKM", "+993", "🇹🇲")
        case .turksAndCaicosIslands:  return Description("", "TCA", "+1", "🇹🇨")
        case .tulavu:                 return Description("", "TUV", "+688", "🇹🇻")
        /* U */
        case .uganda:              return Description("", "UGA", "+256", "🇺🇬")
        case .ukraine:             return Description("", "UKR", "+380", "🇺🇦")
        case .unitedArabEmirates:  return Description("", "ARE", "+971", "🇦🇪")
        case .unitedKingdom:       return Description("", "GBR", "+44", "🇬🇧", "en")
        case .unitedStates:        return Description("", "USA", "+1", "🇺🇸")
        case .uruguay:             return Description("", "URY", "+598", "🇺🇾")
        case .uzbekistan:          return Description("", "UZB", "+998", "🇺🇿")
        /* V */
        case .vanuatu:               return Description("", "VUT", "+678", "🇻🇺")
        case .venezuela:             return Description("", "VEN", "+58", "🇻🇪")
        case .vietnam:               return Description("", "VNM", "+84", "🇻🇳")
        case .virginIslandsBritish:  return Description("", "VGB", "+1", "🇻🇬")
        case .virginIslandsUS:       return Description("", "VIR", "+1", "🇻🇮")
        /* W */
        case .wallisAndFutuna:  return Description("", "WLF", "+681", "🇼🇫")
        /* X */
        /* Y */
        case .yemen: return Description("", "YEM", "+967", "🇾🇪")
        /* Z */
        case .zambia:    return Description("", "ZMB", "+260", "🇿🇲")
        case .zimbabwe:  return Description("", "ZWE", "+263", "🇿🇼")
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
