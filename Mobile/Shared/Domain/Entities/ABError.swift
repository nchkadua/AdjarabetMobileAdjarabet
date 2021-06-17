//
//  ABError.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/28/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 ABError is domain entity which defines any error
 which could be displayed to user.

 Each error has 'description' which defines specifications of error.

 ABError entity supports mapping from any kind of error
 to ABError errors with initializers.
 */
enum ABError {
    case sessionUninitialized
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

// MARK: - Core API Error -> ABError
extension ABError {
    init(coreStatusCode: AdjarabetCoreStatusCode) {
        self = .default
    }
}

// MARK: - Data Transfer Error -> ABError
extension ABError {
    init(dataTransferError: DataTransferError) {
        self = .default
    }
}

// MARK: - Implement Error Protocol
extension ABError: LocalizedError {
    var errorDescription: String? { description.description }
}
