//
//  GenderEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum GenderEntity: Int {
    case female
    case male
    case other
    case preferNotToSay

    public var description: Description {
        switch self {
        case .female:         return Description(stringValue: "Female")
        case .male:           return Description(stringValue: "Male")
        case .other:          return Description(stringValue: "Other")
        case .preferNotToSay: return Description(stringValue: "Prefer Not To Say")
        }
    }

    public struct Description {
        public let stringValue: String
    }
}
