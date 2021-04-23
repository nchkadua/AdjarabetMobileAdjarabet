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
            case "7393": self = .AAJSlot
            case "7394": self = .ABJSlot
            case "7395": self = .ADJSlot
            case "7396": self = .AGJSlot
            case "7390": self = .AOTJSlot
            case "7400": self = .BHJSlot
            case "7401": self = .BHSJSlot
            case "7397": self = .BHTJSlot
            case "7398": self = .BOMJSlot
         // case "": self = .BRDJSlot      // Ask for Game ID to Saba
            case "7405": self = .CBJSlot
         // case "": self = .CDJSlot       // Ask for Game ID to Saba
            case "7402": self = .CHJSlot
            case "7403": self = .CMJSlot
            case "7409": self = .DARJSlot
         // case "": self = .EDJSlot       // Ask for Game ID to Saba
            case "7417": self = .EHJSlot
            case "7388": self = .EOWJSlot
            case "9675": self = .EPJSlot
            case "7415": self = .ESJSlot
            case "7386": self = .FABJSlot
            case "7375": self = .FBHJSlot
            case "7376": self = .FBHSJSlot
            case "7382": self = .FBHTJSlot
            case "7421": self = .FBJSlot
            case "7383": self = .FDHJSlot
            case "7384": self = .FGSJSlot
            case "7420": self = .FHEJSlot
            case "7419": self = .FHJSlot
            case "7377": self = .FHNCJSlot
            case "7387": self = .FHSJSlot
            case "7378": self = .FLKJSlot
            case "7379": self = .FMCJSlot
         // case "": self = .FSDJSlot      // Ask for Game ID to Saba
            case "7380": self = .FSHJSlot
            case "7432": self = .GEJSlot
            case "7476": self = .GETJSlot
            case "7429": self = .GOCJSlot
            case "7426": self = .GOLJSlot
            case "7430": self = .GTSJSlot
            case "7361": self = .HBHJSlot
            case "7362": self = .HCJSlot
            case "7434": self = .HNCJSlot
            case "7363": self = .HSHJSlot
            case "7436": self = .IGTJSlot
            case "9674": self = .IVJSlot
            case "7441": self = .KGJSlot
            case "9411": self = .KHJSlot
            case "7445": self = .LAWJSlot
            case "7447": self = .LHJSlot
            case "7449": self = .MFJSlot
            case "7453": self = .MLAWJSlot
            case "7448": self = .MPJSlot
            case "9710": self = .MTJSlot
            case "7455": self = .OCJSlot
            case "7456": self = .OGJSlot
            case "9412": self = .PQJSlot
            case "7457": self = .PSJSlot
            case "7458": self = .QORJSlot
            case "9643": self = .RCJSlot
         // case "": self = .RGJSlot       // Ask for Game ID to Saba
            case "7459": self = .RLJSlot
            case "7463": self = .RORJSlot
            case "7465": self = .RSJSlot
            case "7461": self = .RTSJSlot
            case "7462": self = .RWJSlot
            case "7470": self = .SBJSlot
            case "7468": self = .SCJSlot
            case "7472": self = .SHJSlot
            case "7467": self = .SOAJSlot
            case "7469": self = .SPJSlot
            case "7471": self = .STJSlot
            case "7365": self = .TBHJSlot
            case "7360": self = .TBHTJSlot
            case "7366": self = .TDHJSlot
            case "7367": self = .TDJSlot
            case "7364": self = .TDRJSlot
         // case "": self = .TGCJSlot      // Ask for Game ID to Saba
            case "7368": self = .THBJSlot
            case "7369": self = .TJRJSlot
            case "7372": self = .TSFJSlot
            case "7370": self = .TSHJSlot
            case "7478": self = .TSOAJSlot
         // case "": self = .TSOATJSlot    // Ask for Game ID to Saba
            case "7371": self = .TSWJSlot
            case "7479": self = .TWWJSlot
            case "7481": self = .UHJSlot
            case "7484": self = .VGJSlot
            case "7482": self = .VNJSlot
            case "7486": self = .VWJSlot
            case "7489": self = .WHJSlot
            case "7416": self = .XSJSlot
            case "7490": self = .ZWJSlot
            default: return nil
            }
        default: return nil
        }
    }
}
