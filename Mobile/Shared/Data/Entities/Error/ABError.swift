//
//  ABError.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/28/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

enum ABError {
    case wrongAuthCredentials
    // general errors
    case from(_ error: Error)
    case `init`(description: Description = .init())
    case `default`

    var description: Description {
        switch self {
        case .wrongAuthCredentials:
            return .init(description: R.string.localization.shared_aberror_wrong_auth_credentials_description.localized())
        // add more errors here!
        case .from(let error):
            return .init(description: error.localizedDescription)
        case .`init`(let description):
            return description
        default:
            return .init()
        }
    }

    class Description {
        typealias DescriptionType = String
        var description: DescriptionType

        typealias OnOkActionType = () -> Void
        var onOkAction: OnOkActionType

        typealias OnCancelActionType = () -> Void
        var onCancelAction: OnCancelActionType

        init (
            description: DescriptionType = R.string.localization.shared_aberror_default_description.localized(),
            onOkAction: @escaping OnOkActionType = { },
            onCancelAction: @escaping OnCancelActionType = { }
        ) {
            self.description = description
            self.onOkAction = onOkAction
            self.onCancelAction = onCancelAction
        }
    }
}

extension ABError: LocalizedError {
    var errorDescription: String? { description.description }
}
