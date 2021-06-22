//
//  Status.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public enum Status {
    case active
    case deleted

    public var description: Description {
        switch self {
        case .active: return Description(stringValue: "Active")
        case .deleted: return Description(stringValue: "Deleted")
        }
    }

    public struct Description {
        public let stringValue: String
    }
}

// MARK: - status ID Constructor -- Core API extension
public extension Status {
    init?(statusId: Int) {
        switch statusId {
        case 0: self = .active
        case 1: self = .deleted
        default: return nil
        }
    }
}
