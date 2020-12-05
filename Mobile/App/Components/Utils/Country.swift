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
    case alandIslands
    case albania
    case algeria
    case americanSamoa
    case andorra
    case angola
    case anguilla
    case antarctica
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
    case bonaireSintEustatiusAndSaba
    case bosniaAndHerzegovina
    case botswana
    case bouvetIsland
    case brazil
    case britishIndianOceanTerritory
    case brunei
    case bulgaria
    case burtkinaFaso
    case burundi
    case cambodia // C
    case cameroom
    case canada
    case capeVerde
    case caymanIslands
    case centralAfricanRepublic
    case chad
    case chile
    case china
    case christmasIsland
    case cocosIslands
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
 // case frenchSouthernTerritories: ATF, nil, 🇹🇫
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
    case guernsey
    case guinea
    case guineaBissau
    case guyana
    case haiti // H
    case heardIslandAndMcDonaldIslands
    case honduras
    case hongKong
    case hungary
    case iceland // I
    case india
    case indonesia
    case iran
    case iraq
    case ireland
    case isleOfMand
    case israel
    case italy
    case jamaica // J
    case japan
    case jersey
    case jordan // next should be kazakhstan
    case kenya // K
    case kiribati
    case kosovo
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
    case mayotte
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
    case norfolkIsland
    case northKorea
    case northernMarianaIslands
    case norway
    case oman // O
    case pakistan // in the bag // P
    case palau
    case palestine
    case panama
    case papuaNewGuinea
    case paraguay
    case peru
    case phillipines
    case pitcairn
    case poland
    case puertoRico
    case qatar // Q
    case reunion // R
    case romania
    case russia
    case rwanda
    case saintBarthelemy // S
    case saintHelena
    case saintKittsAndNevis
    case saintLucia
    case saintMartin
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
    case southGeorgiaAndTheSouthSandwichIslands
    case southKorea
    case southSudan
    case spain
    case sriLanka
    case sudan
    case suriname
    case svalbardAndJanMayen
    case swaziland
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
    case unitedStatesMinorOutlyingIslands
    case uruguay
    case uzbekistan
    case vanuatu // V
    case vaticanCity
    case venezuela
    case vietnam
    case virginIslandsBritish
    case virginIslandsUS
    case wallisAndFutuna // W
    case westernSahara
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
        case .afghanistan:        return Description(r.afghanistan.localized(), "AFG", "+93", "🇦🇫")
        case .alandIslands:       return Description(r.alandIslands.localized(), "ALA", "+358", "🇦🇽")
        case .albania:            return Description(r.albania.localized(), "ALB", "+335", "🇦🇱")
        case .algeria:            return Description(r.algeria.localized(), "DZA", "+213", "🇩🇿")
        case .americanSamoa:      return Description(r.americanSamoa.localized(), "ASM", "+1", "🇦🇸")
        case .andorra:            return Description(r.andorra.localized(), "AND", "+376", "🇦🇩")
        case .angola:             return Description(r.angola.localized(), "AGO", "+244", "🇦🇴")
        case .anguilla:           return Description(r.anguilla.localized(), "AIA", "+1", "🇦🇮")
        case .antarctica:         return Description(r.antarctica.localized(), "ATA", "+672", "🇦🇶")
        case .antiguaAndBarbuda:  return Description(r.antiguaAndBarbuda.localized(), "ATG", "+1", "🇦🇬")
        case .argentina:          return Description(r.argentina.localized(), "ARG", "+54", "🇦🇷")
        case .aruba:              return Description(r.aruba.localized(), "ABW", "+297", "🇦🇼")
        case .australia:          return Description(r.australia.localized(), "AUS", "+61", "🇦🇺")
        case .austria:            return Description(r.austria.localized(), "AUT", "+43", "🇦🇹")
        /* B */
        case .bahamas:                      return Description(r.bahamas.localized(), "BHS", "+1", "🇧🇸")
        case .bahrain:                      return Description(r.bahrain.localized(), "BHR", "+973", "🇧🇭")
        case .bangladesh:                   return Description(r.bangladesh.localized(), "BGD", "+880", "🇧🇩")
        case .barbados:                     return Description(r.barbados.localized(), "BRB", "+1", "🇧🇧")
        case .belarus:                      return Description(r.belarus.localized(), "BLR", "+375", "🇧🇾")
        case .belgium:                      return Description(r.belgium.localized(), "BEL", "+32", "🇧🇪")
        case .belize:                       return Description(r.belize.localized(), "BLZ", "+501", "🇧🇿")
        case .benin:                        return Description(r.benin.localized(), "NEB", "+229", "🇧🇯")
        case .bermuda:                      return Description(r.bermuda.localized(), "BMU", "+1", "🇧🇲")
        case .bhutan:                       return Description(r.bhutan.localized(), "BTN", "+975", "🇧🇹")
        case .bolivia:                      return Description(r.bolivia.localized(), "BOL", "+591", "🇧🇴")
        case .bonaireSintEustatiusAndSaba:  return Description(r.bonaireSintEustatiusAndSaba.localized(), "BES", "+599", "🇧🇶")
        case .bosniaAndHerzegovina:         return Description(r.bosniaAndHerzegovina.localized(), "BIH", "+387", "🇧🇦")
        case .botswana:                     return Description(r.botswana.localized(), "BWA", "+267", "🇧🇼")
        case .bouvetIsland:                 return Description(r.bouvetIsland.localized(), "BVT", "+47", "🇧🇻")
        case .brazil:                       return Description(r.brazil.localized(), "BRA", "+55", "🇧🇷")
        case .britishIndianOceanTerritory:  return Description(r.britishIndianOceanTerritory.localized(), "IOR", "+246", "🇮🇴")
        case .brunei:                       return Description(r.brunei.localized(), "BRN", "+673", "🇧🇳")
        case .bulgaria:                     return Description(r.bulgaria.localized(), "BGR", "+359", "🇧🇬")
        case .burtkinaFaso:                 return Description(r.burtkinaFaso.localized(), "BFA", "+226", "🇧🇫")
        case .burundi:                      return Description(r.burundi.localized(), "BDI", "+257", "🇧🇮")
        /* C */
        case .cambodia:                return Description(r.cambodia.localized(), "KHM", "+855", "🇰🇭")
        case .cameroom:                return Description(r.cameroom.localized(), "CMR", "+237", "🇨🇲")
        case .canada:                  return Description(r.canada.localized(), "CAN", "+1", "🇨🇦")
        case .capeVerde:               return Description(r.capeVerde.localized(), "CPV", "+238", "🇨🇻")
        case .caymanIslands:           return Description(r.caymanIslands.localized(), "CYM", "+1", "🇰🇾")
        case .centralAfricanRepublic:  return Description(r.centralAfricanRepublic.localized(), "CAF", "+236", "🇨🇫")
        case .chad:                    return Description(r.chad.localized(), "TCD", "+235", "🇹🇩")
        case .chile:                   return Description(r.chile.localized(), "CHL", "+56", "🇨🇱")
        case .china:                   return Description(r.china.localized(), "CHN", "+86", "🇨🇳")
        case .christmasIsland:         return Description(r.christmasIsland.localized(), "CXR", "+61", "🇨🇽")
        case .cocosIslands:            return Description(r.cocosIslands.localized(), "CCK", "+61", "🇨🇨")
        case .colombia:                return Description(r.colombia.localized(), "COL", "+57", "🇨🇴")
        case .coromos:                 return Description(r.coromos.localized(), "COM", "+269", "🇰🇲")
        case .congo:                   return Description(r.congo.localized(), "COG", "+242", "🇨🇬")
        case .cookIsland:              return Description(r.cookIsland.localized(), "COK", "+682", "🇨🇰")
        case .costaRica:               return Description(r.costaRica.localized(), "CRI", "+506", "🇨🇷")
        case .croatia:                 return Description(r.croatia.localized(), "HRV", "+385", "🇭🇷")
        case .cuba:                    return Description(r.cuba.localized(), "CUB", "+53", "🇨🇺")
        case .curacao:                 return Description(r.curacao.localized(), "CUW", "+599", "🇨🇼")
        case .cyprus:                  return Description(r.cyprus.localized(), "CYP", "+357", "🇨🇾")
        case .czechRepublic:           return Description(r.czechRepublic.localized(), "CZE", "+420", "🇨🇿")
        /* D */
        case .democraticRepublicOfTheCongo:  return Description(r.democraticRepublicOfTheCongo.localized(), "COD", "+243", "🇨🇩")
        case .denmark:                       return Description(r.denmark.localized(), "DNK", "+45", "🇩🇰")
        case .djibouti:                      return Description(r.djibouti.localized(), "DJI", "+253", "🇩🇯")
        case .dominica:                      return Description(r.dominica.localized(), "DMA", "+1", "🇩🇲")
        case .dominicanRepublic:             return Description(r.dominicanRepublic.localized(), "DOM", "+1", "🇩🇴")
        /* E */
        case .ecuador:           return Description(r.ecuador.localized(), "ECU", "+593", "🇪🇨")
        case .egypt:             return Description(r.egypt.localized(), "EGY", "+20", "🇪🇬")
        case .elSalvador:        return Description(r.elSalvador.localized(), "SLV", "+503", "🇸🇻")
        case .equatorialGuinea:  return Description(r.equatorialGuinea.localized(), "GNQ", "+240", "🇬🇶")
        case .eritrea:           return Description(r.eritrea.localized(), "ERI", "+291", "🇪🇷")
        case .estonia:           return Description(r.estonia.localized(), "EST", "+372", "🇪🇪")
        case .ethiopia:          return Description(r.ethiopia.localized(), "ETH", "+251", "🇪🇹")
        /* F */
        case .falklandIslands:  return Description(r.falklandIslands.localized(), "FLK", "+500", "🇫🇰")
        case .faroeIslands:     return Description(r.faroeIslands.localized(), "FRO", "+298", "🇫🇴")
        case .fiji:             return Description(r.fiji.localized(), "FJI", "+679", "🇫🇯")
        case .finland:          return Description(r.finland.localized(), "FIN", "+358", "🇫🇮")
        case .france:           return Description(r.france.localized(), "FRA", "+33", "🇫🇷")
        case .frenchGuiana:     return Description(r.frenchGuiana.localized(), "GUF", "+594", "🇬🇫")
        case .frenchPolynesia:  return Description(r.frenchPolynesia.localized(), "PYF", "+689", "🇵🇫")
        /* G */
        case .gabon:         return Description(r.gabon.localized(), "GAB", "+241", "🇬🇦")
        case .gambia:        return Description(r.gambia.localized(), "GMB", "+220", "🇬🇲")
        case .germany:       return Description(r.germany.localized(), "DEU", "+49", "🇩🇪")
        case .ghana:         return Description(r.ghana.localized(), "GHA", "+233", "🇬🇭")
        case .gibraltar:     return Description(r.gibraltar.localized(), "GIB", "+350", "🇬🇮")
        case .greece:        return Description(r.greece.localized(), "GRC", "+30", "🇬🇷")
        case .greenland:     return Description(r.greenland.localized(), "GRL", "+299", "🇬🇱")
        case .grenada:       return Description(r.grenada.localized(), "GRD", "+1", "🇬🇩")
        case .guadaloupe:    return Description(r.guadaloupe.localized(), "GLP", "+590", "🇬🇵")
        case .guam:          return Description(r.guam.localized(), "GUM", "+1", "🇬🇺")
        case .guatemala:     return Description(r.guatemala.localized(), "GTM", "+502", "🇬🇹")
        case .guernsey:      return Description(r.guernsey.localized(), "GGY", "+44", "🇬🇬")
        case .guinea:        return Description(r.guinea.localized(), "GIN", "+224", "🇬🇳")
        case .guineaBissau:  return Description(r.guineaBissau.localized(), "GNB", "+245", "🇬🇼")
        case .guyana:        return Description(r.guyana.localized(), "GUY", "+592", "🇬🇾")
        /* H */
        case .haiti:                          return Description(r.haiti.localized(), "HTI", "+509", "🇭🇹")
        case .heardIslandAndMcDonaldIslands:  return Description(r.heardIslandAndMcDonaldIslands.localized(), "HMD", "+672", "🇭🇲")
        case .honduras:                       return Description(r.honduras.localized(), "HND", "+504", "🇭🇳")
        case .hongKong:                       return Description(r.hongKong.localized(), "HKG", "+852", "🇭🇰")
        case .hungary:                        return Description(r.hungary.localized(), "HUN", "+36", "🇭🇺")
        /* I */
        case .iceland:     return Description(r.iceland.localized(), "ISL", "+354", "🇮🇸")
        case .india:       return Description(r.india.localized(), "IND", "+91", "🇮🇳")
        case .indonesia:   return Description(r.indonesia.localized(), "IDN", "+62", "🇮🇩")
        case .iran:        return Description(r.iran.localized(), "IRN", "+98", "🇮🇷")
        case .iraq:        return Description(r.iraq.localized(), "IRQ", "+964", "🇮🇶")
        case .ireland:     return Description(r.ireland.localized(), "IRL", "+353", "🇮🇪")
        case .isleOfMand:  return Description(r.isleOfMand.localized(), "IMN", "+44", "🇮🇲")
        case .israel:      return Description(r.israel.localized(), "ISR", "+972", "🇮🇱")
        case .italy:       return Description(r.italy.localized(), "ITA", "+39", "🇮🇹")
        /* J */
        case .jamaica:  return Description(r.jamaica.localized(), "JAM", "+1", "🇯🇲")
        case .japan:    return Description(r.japan.localized(), "JPN", "+81", "🇯🇵")
        case .jersey:   return Description(r.jersey.localized(), "JEY", "+44", "🇯🇪")
        case .jordan:   return Description(r.jordan.localized(), "JOR", "+962", "🇯🇴")
        /* K */
        case .kenya:       return Description(r.kenya.localized(), "KEN", "+254", "🇰🇪")
        case .kiribati:    return Description(r.kiribati.localized(), "KIR", "+686", "🇰🇮")
        case .kosovo:      return Description(r.kosovo.localized(), "UNK", "+383", "🇽🇰")
        case .kuwait:      return Description(r.kuwait.localized(), "KWT", "+965", "🇰🇼")
        case .kyrgyzstan:  return Description(r.kyrgyzstan.localized(), "KGZ", "+996", "🇰🇬")
        /* L */
        case .laos:           return Description(r.laos.localized(), "LAO", "+856", "🇱🇦")
        case .latvia:         return Description(r.latvia.localized(), "LVA", "+371", "🇱🇻")
        case .lebanon:        return Description(r.lebanon.localized(), "LBN", "+961", "🇱🇧")
        case .lesotho:        return Description(r.lesotho.localized(), "LSO", "+266", "🇱🇸")
        case .liberia:        return Description(r.liberia.localized(), "LBR", "+231", "🇱🇷")
        case .libya:          return Description(r.libya.localized(), "LBY", "+218", "🇱🇾")
        case .liechtenstein:  return Description(r.liechtenstein.localized(), "LIE", "+423", "🇱🇮")
        case .lithuania:      return Description(r.lithuania.localized(), "LTU", "+370", "🇱🇹")
        case .luxembourg:     return Description(r.luxembourg.localized(), "LUX", "+352", "🇱🇺")
        /* M */
        case .macao:            return Description(r.macao.localized(), "MAC", "+853", "🇲🇴")
        case .macedonia:        return Description(r.macedonia.localized(), "MKD", "+389", "🇲🇰")
        case .madagascar:       return Description(r.madagascar.localized(), "MDG", "+261", "🇲🇬")
        case .malawi:           return Description(r.malawi.localized(), "MWI", "+265", "🇲🇼")
        case .malaysia:         return Description(r.malaysia.localized(), "MYS", "+60", "🇲🇾")
        case .maldives:         return Description(r.maldives.localized(), "MDV", "+960", "🇲🇻")
        case .mali:             return Description(r.mali.localized(), "MLI", "+223", "🇲🇱")
        case .malta:            return Description(r.malta.localized(), "MLT", "+356", "🇲🇹")
        case .marshallIslands:  return Description(r.marshallIslands.localized(), "MHL", "+692", "🇲🇭")
        case .mantinique:       return Description(r.mantinique.localized(), "MTQ", "+596", "🇲🇶")
        case .mauritania:       return Description(r.mauritania.localized(), "MRT", "+222", "🇲🇷")
        case .mauritius:        return Description(r.mauritius.localized(), "MUS", "+230", "🇲🇺")
        case .mayotte:          return Description(r.mayotte.localized(), "MYT", "+262", "🇾🇹")
        case .mexico:           return Description(r.mexico.localized(), "MEX", "+52", "🇲🇽")
        case .micronesia:       return Description(r.micronesia.localized(), "FSM", "+691", "🇫🇲")
        case .moldava:          return Description(r.moldava.localized(), "MDA", "+373", "🇲🇩")
        case .monaco:           return Description(r.monaco.localized(), "MCO", "+377", "🇲🇨")
        case .mongolia:         return Description(r.mongolia.localized(), "MNG", "+976", "🇲🇳")
        case .montenegro:       return Description(r.montenegro.localized(), "MNE", "+382", "🇲🇪")
        case .montserrat:       return Description(r.montserrat.localized(), "MSR", "+1", "🇲🇸")
        case .morocco:          return Description(r.morocco.localized(), "MAR", "+212", "🇲🇦")
        case .mozambique:       return Description(r.mozambique.localized(), "MOZ", "+258", "🇲🇿")
        case .myanmar:          return Description(r.myanmar.localized(), "MMR", "+95", "🇲🇲")
        /* N */
        case .namibia:                 return Description(r.namibia.localized(), "NAM", "+264", "🇳🇦")
        case .nauru:                   return Description(r.nauru.localized(), "NRU", "+674", "🇳🇷")
        case .nepal:                   return Description(r.nepal.localized(), "NPL", "+977", "🇳🇵")
        case .netherlands:             return Description(r.netherlands.localized(), "NLD", "+31", "🇳🇱")
        case .newCaledonia:            return Description(r.newCaledonia.localized(), "NCL", "+687", "🇳🇨")
        case .newZealand:              return Description(r.newZealand.localized(), "NZL", "+64", "🇳🇿")
        case .nicaragua:               return Description(r.nicaragua.localized(), "NIC", "+505", "🇳🇮")
        case .niger:                   return Description(r.niger.localized(), "NER", "+227", "🇳🇪")
        case .nigeria:                 return Description(r.nigeria.localized(), "NGA", "+234", "🇳🇬")
        case .niue:                    return Description(r.niue.localized(), "NIU", "+683", "🇳🇺")
        case .norfolkIsland:           return Description(r.norfolkIsland.localized(), "NFK", "+672", "🇳🇫")
        case .northKorea:              return Description(r.northKorea.localized(), "PRK", "+850", "🇰🇵")
        case .northernMarianaIslands:  return Description(r.northernMarianaIslands.localized(), "MNP", "+1", "🇲🇵")
        case .norway:                  return Description(r.norway.localized(), "NOR", "+47", "🇳🇴")
        /* O */
        case .oman:  return Description(r.oman.localized(), "OMN", "+968", "🇴🇲")
        /* P */
        case .pakistan:        return Description(r.pakistan.localized(), "PAK", "+92", "🇵🇰")
        case .palau:           return Description(r.palau.localized(), "PLW", "+680", "🇵🇼")
        case .palestine:       return Description(r.palestine.localized(), "PSE", "+970", "🇵🇸")
        case .panama:          return Description(r.panama.localized(), "PAN", "+507", "🇵🇦")
        case .papuaNewGuinea:  return Description(r.papuaNewGuinea.localized(), "PNG", "+675", "🇵🇬")
        case .paraguay:        return Description(r.paraguay.localized(), "PRY", "+595", "🇵🇾")
        case .peru:            return Description(r.peru.localized(), "PER", "+51", "🇵🇪")
        case .phillipines:     return Description(r.phillipines.localized(), "PHL", "+63", "🇵🇭")
        case .pitcairn:        return Description(r.pitcairn.localized(), "PCN", "+64", "🇵🇳")
        case .poland:          return Description(r.poland.localized(), "POL", "+48", "🇵🇱")
        case .puertoRico:      return Description(r.puertoRico.localized(), "PRI", "+1", "🇵🇷")
        /* Q */
        case .qatar:  return Description(r.qatar.localized(), "QAT", "+974", "🇶🇦")
        /* R */
        case .reunion:  return Description(r.reunion.localized(), "REU", "+262", "🇷🇪")
        case .romania:  return Description(r.romania.localized(), "ROU", "+40", "🇷🇴")
        case .russia:   return Description(r.russia.localized(), "RUS", "+7", "🇷🇺")
        case .rwanda:   return Description(r.rwanda.localized(), "RWA", "+250", "🇷🇼")
        /* S */
        case .saintBarthelemy:                         return Description(r.saintBarthelemy.localized(), "BLM", "+590", "🇧🇱")
        case .saintHelena:                             return Description(r.saintHelena.localized(), "SHN", "+290", "🇸🇭")
        case .saintKittsAndNevis:                      return Description(r.saintKittsAndNevis.localized(), "KNA", "+1", "🇰🇳")
        case .saintLucia:                              return Description(r.saintLucia.localized(), "LCA", "+1", "🇱🇨")
        case .saintMartin:                             return Description(r.saintMartin.localized(), "MAF", "+599", "🇲🇫")
        case .saintPierreAndMiquelon:                  return Description(r.saintPierreAndMiquelon.localized(), "SPM", "+508", "🇵🇲")
        case .saintVincentAndTheGrenadines:            return Description(r.saintVincentAndTheGrenadines.localized(), "VCT", "+1", "🇻🇨")
        case .samoa:                                   return Description(r.samoa.localized(), "WSM", "+685", "🇼🇸")
        case .sanMarino:                               return Description(r.sanMarino.localized(), "SMR", "+378", "🇸🇲")
        case .saoTomeAndPrincipe:                      return Description(r.saoTomeAndPrincipe.localized(), "STP", "+239", "🇸🇹")
        case .saudiArabia:                             return Description(r.saudiArabia.localized(), "SAU", "+966", "🇸🇦")
        case .senegal:                                 return Description(r.senegal.localized(), "SEN", "+221", "🇸🇳")
        case .serbia:                                  return Description(r.serbia.localized(), "SRB", "+381", "🇷🇸")
        case .seychelles:                              return Description(r.seychelles.localized(), "SYC", "+248", "🇸🇨")
        case .sierraLeone:                             return Description(r.sierraLeone.localized(), "SLE", "+232", "🇸🇱")
        case .singapore:                               return Description(r.singapore.localized(), "SGP", "+65", "🇸🇬")
        case .sintMaarten:                             return Description(r.sintMaarten.localized(), "SXM", "+1", "🇸🇽")
        case .slovakia:                                return Description(r.slovakia.localized(), "SVK", "+421", "🇸🇰")
        case .slovenia:                                return Description(r.slovenia.localized(), "SVN", "+386", "🇸🇮")
        case .solomonIslands:                          return Description(r.solomonIslands.localized(), "SLB", "+677", "🇸🇧")
        case .somalia:                                 return Description(r.somalia.localized(), "SOM", "+252", "🇸🇴")
        case .southAfrica:                             return Description(r.southAfrica.localized(), "ZAF", "+27", "🇿🇦")
        case .southGeorgiaAndTheSouthSandwichIslands:  return Description(r.southGeorgiaAndTheSouthSandwichIslands.localized(), "SGS", "+500", "🇬🇸")
        case .southKorea:                              return Description(r.southKorea.localized(), "KOR", "+82", "🇰🇷")
        case .southSudan:                              return Description(r.southSudan.localized(), "SSD", "+211", "🇸🇸")
        case .spain:                                   return Description(r.spain.localized(), "ESP", "+34", "🇪🇸")
        case .sriLanka:                                return Description(r.sriLanka.localized(), "LKA", "+94", "🇱🇰")
        case .sudan:                                   return Description(r.sudan.localized(), "SDN", "+249", "🇸🇩")
        case .suriname:                                return Description(r.suriname.localized(), "SUR", "+597", "🇸🇷")
        case .svalbardAndJanMayen:                     return Description(r.svalbardAndJanMayen.localized(), "SJM", "+47", "🇸🇯")
        case .swaziland:                               return Description(r.swaziland.localized(), "SWZ", "+268", "🇸🇿")
        case .sweden:                                  return Description(r.sweden.localized(), "SWE", "+46", "🇸🇪")
        case .switzerland:                             return Description(r.switzerland.localized(), "CHE", "+41", "🇨🇭")
        case .syria:                                   return Description(r.syria.localized(), "SYR", "+963", "🇸🇾")
        /* T */
        case .taiwan:                 return Description(r.taiwan.localized(), "TWN", "+886", "🇹🇼")
        case .tajikistan:             return Description(r.tajikistan.localized(), "TJK", "+992", "🇹🇯")
        case .tanzania:               return Description(r.tanzania.localized(), "TZA", "+255", "🇹🇿")
        case .thailand:               return Description(r.thailand.localized(), "THA", "+66", "🇹🇭")
        case .timorLeste:             return Description(r.timorLeste.localized(), "TLS", "+670", "🇹🇱")
        case .togo:                   return Description(r.togo.localized(), "TGO", "+228", "🇹🇬")
        case .tokelau:                return Description(r.tokelau.localized(), "TKL", "+690", "🇹🇰")
        case .tonga:                  return Description(r.tonga.localized(), "TON", "+676", "🇹🇴")
        case .trinidadAndTobago:      return Description(r.trinidadAndTobago.localized(), "TTO", "+1", "🇹🇹")
        case .tunisia:                return Description(r.tunisia.localized(), "TUN", "+216", "🇹🇳")
        case .turkey:                 return Description(r.turkey.localized(), "TUR", "+90", "🇹🇷")
        case .turkmenistan:           return Description(r.turkmenistan.localized(), "TKM", "+993", "🇹🇲")
        case .turksAndCaicosIslands:  return Description(r.turksAndCaicosIslands.localized(), "TCA", "+1", "🇹🇨")
        case .tulavu:                 return Description(r.tulavu.localized(), "TUV", "+688", "🇹🇻")
        /* U */
        case .uganda:                            return Description(r.uganda.localized(), "UGA", "+256", "🇺🇬")
        case .ukraine:                           return Description(r.ukraine.localized(), "UKR", "+380", "🇺🇦")
        case .unitedArabEmirates:                return Description(r.unitedArabEmirates.localized(), "ARE", "+971", "🇦🇪")
        case .unitedKingdom:                     return Description(r.unitedKingdom.localized(), "GBR", "+44", "🇬🇧", "en")
        case .unitedStates:                      return Description(r.unitedStates.localized(), "USA", "+1", "🇺🇸")
        case .unitedStatesMinorOutlyingIslands:  return Description(r.unitedStatesMinorOutlyingIslands.localized(), "UMI", "+246", "🇺🇸")
        case .uruguay:                           return Description(r.uruguay.localized(), "URY", "+598", "🇺🇾")
        case .uzbekistan:                        return Description(r.uzbekistan.localized(), "UZB", "+998", "🇺🇿")
        /* V */
        case .vanuatu:               return Description(r.vanuatu.localized(), "VUT", "+678", "🇻🇺")
        case .vaticanCity:           return Description(r.vaticanCity.localized(), "VAT", "+379", "🇻🇦")
        case .venezuela:             return Description(r.venezuela.localized(), "VEN", "+58", "🇻🇪")
        case .vietnam:               return Description(r.vietnam.localized(), "VNM", "+84", "🇻🇳")
        case .virginIslandsBritish:  return Description(r.virginIslandsBritish.localized(), "VGB", "+1", "🇻🇬")
        case .virginIslandsUS:       return Description(r.virginIslandsUS.localized(), "VIR", "+1", "🇻🇮")
        /* W */
        case .wallisAndFutuna:  return Description(r.wallisAndFutuna.localized(), "WLF", "+681", "🇼🇫")
        case .westernSahara:    return Description(r.westernSahara.localized(), "ESH", "+212", "🇪🇭")
        /* X */
        /* Y */
        case .yemen: return Description(r.yemen.localized(), "YEM", "+967", "🇾🇪")
        /* Z */
        case .zambia:    return Description(r.zambia.localized(), "ZMB", "+260", "🇿🇲")
        case .zimbabwe:  return Description(r.zimbabwe.localized(), "ZWE", "+263", "🇿🇼")
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
        ("\(stringFlag ?? "") \(alpha3Code) \(phonePrefix)")
    }
}
