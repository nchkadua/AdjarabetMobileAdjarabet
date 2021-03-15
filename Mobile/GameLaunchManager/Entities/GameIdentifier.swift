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
    case BHJSlot
    case RORJSlot

    var description: Description {
        switch self {
        case .BHJSlot:  return Description(tag: "EGT/BHJSlot")
        case .RORJSlot: return Description(tag: "EGT/RORJSlot")
        }
    }

    struct Description {
        let tag: String
    }
}

// MARK: - provider ID and game ID Constructor
extension GameIdentifier {
    init?(providerId: String, gameId: String) {
        switch providerId {
        /* seam-less games */
        case "11e7b7ca-14f1-b0b0-88fc-005056adb106":
            switch gameId {
            /* EGT */
            case "7397": self = .BHJSlot
            case "7463": self = .RORJSlot
            default: return nil
            }

        default: return nil
        }
    }
}
