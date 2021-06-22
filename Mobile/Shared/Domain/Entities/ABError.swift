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
    case wrongAuthCredentials
    case ipIsBlocked
    case sessionNotFound
    case mustBeMoreThanZero
    case accountIsSuspended
    case unableToGetBalance
    case paymentAccountNotFound
    case paymentAccountIsNotVerified
    case unableToSendEmailVerificationEmailIsMissing
    case bonusIsExpired
    // general errors
    case from(_ error: Error)
    case `init`(description: Description = .init())
    case `default`

    var description: Description {
        switch self {
        case .wrongAuthCredentials:
            return .init(description: R.string.localization.shared_aberror_wrong_auth_credentials_description.localized())
        case .ipIsBlocked:
            return .init(description: R.string.localization.shared_aberror_ip_is_blocked.localized())
        case .sessionNotFound:
            return .init(description: R.string.localization.shared_aberror_session_not_found.localized())
        case .mustBeMoreThanZero:
            return .init(description: R.string.localization.shared_aberror_must_be_more_than_zero.localized())
        case .accountIsSuspended:
            return .init(description: R.string.localization.shared_aberror_account_is_suspended.localized())
        case .unableToGetBalance:
            return .init(description: R.string.localization.shared_aberror_unable_to_get_balance.localized())
        case .paymentAccountNotFound:
            return .init(description: R.string.localization.shared_aberror_payment_account_not_found.localized())
        case .paymentAccountIsNotVerified:
            return .init(description: R.string.localization.shared_aberror_payment_account_is_not_verified.localized())
        case .unableToSendEmailVerificationEmailIsMissing:
            return .init(description: R.string.localization.shared_aberror_unable_to_send_email_verification_email_is_missing.localized())
        case .bonusIsExpired:
            return .init(description: R.string.localization.shared_aberror_bonus_is_expired.localized())
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
    init?(coreStatusCode: AdjarabetCoreStatusCode) {
        guard coreStatusCode != .STATUS_SUCCESS
        else { return nil }
        switch coreStatusCode {
        case .USER_WITH_GIVEN_AUTH_CREDENTIALS_NOT_FOUND:          self = .wrongAuthCredentials
        case .IP_IS_BLOCKED:                                       self = .ipIsBlocked
        case .SESSION_NOT_FOUND:                                   self = .sessionNotFound
        case .MUST_BE_MORE_THAN_ZERO:                              self = .mustBeMoreThanZero
        case .ACCOUNT_IS_SUSPENDED:                                self = .accountIsSuspended
        case .UNABLE_TO_GET_BALANCE:                               self = .unableToGetBalance
        case .PAYMENT_ACCOUNT_NOT_FOUND:                           self = .paymentAccountNotFound
        case .PAYMENT_ACCOUNT_IS_NOT_VERIFIED:                     self = .paymentAccountIsNotVerified
        case .UNABLE_TO_SEND_EMAIL_VERIFICATION_EMAIL_IS_MISSING:  self = .unableToSendEmailVerificationEmailIsMissing
        case .BONUS_IS_EXPIRED:                                    self = .bonusIsExpired
        default: self = .default
        }
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
