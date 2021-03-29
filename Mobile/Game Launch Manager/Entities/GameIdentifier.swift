//
//  GameIdentifier.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/3/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 enum for identification of Game
 */
enum GameIdentifier {
    case AAJSlot
    case ABJSlot
    case ADJSlot
    case AGJSlot
    case AOTJSlot
    case BHJSlot
    case BHSJSlot
    case BHTJSlot
    case BOMJSlot
    case BRDJSlot
    case CBJSlot
    case CDJSlot
    case CHJSlot
    case CMJSlot
    case DARJSlot
    case EDJSlot
    case EHJSlot
    case EOWJSlot
    case EPJSlot
    case ESJSlot
    case FABJSlot
    case FBHJSlot
    case FBHSJSlot
    case FBHTJSlot
    case FBJSlot
    case FDHJSlot
    case FGSJSlot
    case FHEJSlot
    case FHJSlot
    case FHNCJSlot
    case FHSJSlot
    case FLKJSlot
    case FMCJSlot
    case FSDJSlot
    case FSHJSlot
    case GEJSlot
    case GETJSlot
    case GOCJSlot
    case GOLJSlot
    case GTSJSlot
    case HBHJSlot
    case HCJSlot
    case HNCJSlot
    case HSHJSlot
    case IGTJSlot
    case IVJSlot
    case KGJSlot
    case KHJSlot
    case LAWJSlot
    case LHJSlot
    case MFJSlot
    case MLAWJSlot
    case MPJSlot
    case MTJSlot
    case OCJSlot
    case OGJSlot
    case PQJSlot
    case PSJSlot
    case QORJSlot
    case RCJSlot
    case RGJSlot
    case RLJSlot
    case RORJSlot
    case RSJSlot
    case RTSJSlot
    case RWJSlot
    case SBJSlot
    case SCJSlot
    case SHJSlot
    case SOAJSlot
    case SPJSlot
    case STJSlot
    case TBHJSlot
    case TBHTJSlot
    case TDHJSlot
    case TDJSlot
    case TDRJSlot
    case TGCJSlot
    case THBJSlot
    case TJRJSlot
    case TSFJSlot
    case TSHJSlot
    case TSOAJSlot
    case TSOATJSlot
    case TSWJSlot
    case TWWJSlot
    case UHJSlot
    case VGJSlot
    case VNJSlot
    case VWJSlot
    case WHJSlot
    case XSJSlot
    case ZWJSlot

    var description: Description {
        switch self {
        case .AAJSlot:     return .init(tag: "AAJSlot")
        case .ABJSlot:     return .init(tag: "ABJSlot")
        case .ADJSlot:     return .init(tag: "ADJSlot")
        case .AGJSlot:     return .init(tag: "AGJSlot")
        case .AOTJSlot:    return .init(tag: "AOTJSlot")
        case .BHJSlot:     return .init(tag: "BHJSlot")
        case .BHSJSlot:    return .init(tag: "BHSJSlot")
        case .BHTJSlot:    return .init(tag: "BHTJSlot")
        case .BOMJSlot:    return .init(tag: "BOMJSlot")
        case .BRDJSlot:    return .init(tag: "BRDJSlot")
        case .CBJSlot:     return .init(tag: "CBJSlot")
        case .CDJSlot:     return .init(tag: "CDJSlot")
        case .CHJSlot:     return .init(tag: "CHJSlot")
        case .CMJSlot:     return .init(tag: "CMJSlot")
        case .DARJSlot:    return .init(tag: "DARJSlot")
        case .EDJSlot:     return .init(tag: "EDJSlot")
        case .EHJSlot:     return .init(tag: "EHJSlot")
        case .EOWJSlot:    return .init(tag: "EOWJSlot")
        case .EPJSlot:     return .init(tag: "EPJSlot")
        case .ESJSlot:     return .init(tag: "ESJSlot")
        case .FABJSlot:    return .init(tag: "FABJSlot")
        case .FBHJSlot:    return .init(tag: "FBHJSlot")
        case .FBHSJSlot:   return .init(tag: "FBHSJSlot")
        case .FBHTJSlot:   return .init(tag: "FBHTJSlot")
        case .FBJSlot:     return .init(tag: "FBJSlot")
        case .FDHJSlot:    return .init(tag: "FDHJSlot")
        case .FGSJSlot:    return .init(tag: "FGSJSlot")
        case .FHEJSlot:    return .init(tag: "FHEJSlot")
        case .FHJSlot:     return .init(tag: "FHJSlot")
        case .FHNCJSlot:   return .init(tag: "FHNCJSlot")
        case .FHSJSlot:    return .init(tag: "FHSJSlot")
        case .FLKJSlot:    return .init(tag: "FLKJSlot")
        case .FMCJSlot:    return .init(tag: "FMCJSlot")
        case .FSDJSlot:    return .init(tag: "FSDJSlot")
        case .FSHJSlot:    return .init(tag: "FSHJSlot")
        case .GEJSlot:     return .init(tag: "GEJSlot")
        case .GETJSlot:    return .init(tag: "GETJSlot")
        case .GOCJSlot:    return .init(tag: "GOCJSlot")
        case .GOLJSlot:    return .init(tag: "GOLJSlot")
        case .GTSJSlot:    return .init(tag: "GTSJSlot")
        case .HBHJSlot:    return .init(tag: "HBHJSlot")
        case .HCJSlot:     return .init(tag: "HCJSlot")
        case .HNCJSlot:    return .init(tag: "HNCJSlot")
        case .HSHJSlot:    return .init(tag: "HSHJSlot")
        case .IGTJSlot:    return .init(tag: "IGTJSlot")
        case .IVJSlot:     return .init(tag: "IVJSlot")
        case .KGJSlot:     return .init(tag: "KGJSlot")
        case .KHJSlot:     return .init(tag: "KHJSlot")
        case .LAWJSlot:    return .init(tag: "LAWJSlot")
        case .LHJSlot:     return .init(tag: "LHJSlot")
        case .MFJSlot:     return .init(tag: "MFJSlot")
        case .MLAWJSlot:   return .init(tag: "MLAWJSlot")
        case .MPJSlot:     return .init(tag: "MPJSlot")
        case .MTJSlot:     return .init(tag: "MTJSlot")
        case .OCJSlot:     return .init(tag: "OCJSlot")
        case .OGJSlot:     return .init(tag: "OGJSlot")
        case .PQJSlot:     return .init(tag: "PQJSlot")
        case .PSJSlot:     return .init(tag: "PSJSlot")
        case .QORJSlot:    return .init(tag: "QORJSlot")
        case .RCJSlot:     return .init(tag: "RCJSlot")
        case .RGJSlot:     return .init(tag: "RGJSlot")
        case .RLJSlot:     return .init(tag: "RLJSlot")
        case .RORJSlot:    return .init(tag: "RORJSlot")
        case .RSJSlot:     return .init(tag: "RSJSlot")
        case .RTSJSlot:    return .init(tag: "RTSJSlot")
        case .RWJSlot:     return .init(tag: "RWJSlot")
        case .SBJSlot:     return .init(tag: "SBJSlot")
        case .SCJSlot:     return .init(tag: "SCJSlot")
        case .SHJSlot:     return .init(tag: "SHJSlot")
        case .SOAJSlot:    return .init(tag: "SOAJSlot")
        case .SPJSlot:     return .init(tag: "SPJSlot")
        case .STJSlot:     return .init(tag: "STJSlot")
        case .TBHJSlot:    return .init(tag: "TBHJSlot")
        case .TBHTJSlot:   return .init(tag: "TBHTJSlot")
        case .TDHJSlot:    return .init(tag: "TDHJSlot")
        case .TDJSlot:     return .init(tag: "TDJSlot")
        case .TDRJSlot:    return .init(tag: "TDRJSlot")
        case .TGCJSlot:    return .init(tag: "TGCJSlot")
        case .THBJSlot:    return .init(tag: "THBJSlot")
        case .TJRJSlot:    return .init(tag: "TJRJSlot")
        case .TSFJSlot:    return .init(tag: "TSFJSlot")
        case .TSHJSlot:    return .init(tag: "TSHJSlot")
        case .TSOAJSlot:   return .init(tag: "TSOAJSlot")
        case .TSOATJSlot:  return .init(tag: "TSOATJSlot")
        case .TSWJSlot:    return .init(tag: "TSWJSlot")
        case .TWWJSlot:    return .init(tag: "TWWJSlot")
        case .UHJSlot:     return .init(tag: "UHJSlot")
        case .VGJSlot:     return .init(tag: "VGJSlot")
        case .VNJSlot:     return .init(tag: "VNJSlot")
        case .VWJSlot:     return .init(tag: "VWJSlot")
        case .WHJSlot:     return .init(tag: "WHJSlot")
        case .XSJSlot:     return .init(tag: "XSJSlot")
        case .ZWJSlot:     return .init(tag: "ZWJSlot")
        }
    }

    struct Description {
        let tag: String
        var fileName: String { tag } // assumption
    }
}

// MARK: - provider ID and game ID Constructor
extension GameIdentifier {
    init?(providerId: String, gameId: String) {
        switch providerId {
        /* Seamless Games */
        case "11e7b7ca-14f1-b0b0-88fc-005056adb106":
            switch gameId {
            /* EGT */
            case "7400": self = .BHJSlot
            case "7463": self = .RORJSlot
            default: return nil
            }

        default: return nil
        }
    }
}
