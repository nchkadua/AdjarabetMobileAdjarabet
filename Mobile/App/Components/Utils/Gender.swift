//
//  Gender.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum Gender {
    case female
    case male
    case other
    case preferNotToSay

    public var description: Description {
        switch self {
        case .female:          return Description(stringValue: R.string.localization.gender_female.localized())
        case .male:            return Description(stringValue: R.string.localization.gender_male.localized())
        case .other:           return Description(stringValue: R.string.localization.gender_other.localized())
        case .preferNotToSay:  return Description(stringValue: R.string.localization.gender_prefer_not_to_say.localized())
        }
    }

    public struct Description {
        public let stringValue: String
    }
}

// MARK: - gender ID Constructor -- Core API extension
public extension Gender {
    init?(genderId: Int) {
        switch genderId {
        case 0: self = .female
        case 1: self = .male
        case 2: self = .other
        case 3: self = .preferNotToSay
        default: return nil
        }
    }
}
