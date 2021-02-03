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
    case egt5BurningHeart

    var description: Description {
        switch self {
        case .egt5BurningHeart: return Description(tag: "EGT")
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

        /* EGT Games */
        case "11e7b7ca-14f1-b0b0-88fc-005056adb106":
            switch gameId {
            case "7382": self = .egt5BurningHeart
            default: return nil
            }

        default: return nil
        }
    }
}
