//
//  ABError.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/28/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit // only for UIImage

/**
 ABError is domain entity which defines any error
 which could be displayed to user.

 Each error has 'description' which defines specifications of error.

 ABError entity supports mapping from any kind of error
 to ABError errors with initializers.
 */

class ABError {
    let type: Type
    lazy var description: Description = {
        switch type {
        case .otpIsRequired:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_otp_is_required.localized(), buttons: [.gotIt]))
        case .accountIsBlocked:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_account_is_blocked.localized(), buttons: [.gotIt, .call]))
        case .oldAndNewValuesMatchError:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_old_and_new_values_match_error.localized(), buttons: [.gotIt]))
        case .accountNotFound:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_account_not_found.localized(), buttons: [.gotIt]))
        case .accessDenied:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_access_denied.localized(), buttons: [.gotIt]))
        case .wrongHash:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_wrong_hash.localized(), buttons: [.gotIt]))
        case .usersDocumentNotFound:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_users_document_not_found.localized(), buttons: [.gotIt]))
        case .insufficientFunds:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_insufficient_funds.localized(), buttons: [.gotIt]))
        case .otpRequestLimitReached:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_otp_request_limit_reached.localized(), buttons: [.gotIt]))
        case .unableToSendOTPTelIsMissing:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_unable_to_send_otp_tel_is_missing.localized(), buttons: [.gotIt]))
        case .failedToSendOTP:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_failed_to_send_otp.localized(), buttons: [.gotIt]))
        case .unableToGenerateOTP:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_unable_to_generate_otp.localized(), buttons: [.gotIt]))
        case .ipIsBlocked:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_ip_is_blocked.localized(), buttons: [.call, .gotIt]))
        case .wrongAuthCredentials:
            return .notification(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_wrong_credentials.localized()))
        case .lastAccessFromDifferentIP:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_last_access_from_different_ip.localized(), buttons: [.lastAccesses, .gotIt]))
        case .wrongRequest, .genericError, .missingParameters, .originDomainNotAllowed:
            return .popup(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_technical_issue.localized(), buttons: [.gotIt]))
        case .otpNotFound:
            return .notification(description: .init(icon: R.image.deposit.add_card_red()!, description: R.string.localization.shared_aberror_otp_not_found.localized()))
        case .notConnected:
            return .status(description: .init(description: R.string.localization.shared_aberror_not_connected.localized()))
        case .`init`(let description):
            return description
        case .from(let error):
            return .popup(description: .init(description: error.localizedDescription))
        default: // also case .default
            return .popup()
        }
    }()

    enum `Type` {
        case otpIsRequired
        case accountIsBlocked
        case oldAndNewValuesMatchError
        case accountNotFound
        case accessDenied
        case wrongHash
        case notFound
        case usersDocumentNotFound
        case insufficientFunds
        case unableToGenerateOTP
        case failedToSendOTP
        case unableToSendOTPTelIsMissing
        case otpRequestLimitReached
        case ipIsBlocked
        case wrongAuthCredentials
        case lastAccessFromDifferentIP
        case wrongRequest
        case genericError
        case missingParameters
        case originDomainNotAllowed
        case otpNotFound
        case notConnected
        case sessionNotFound
        // general errors
        case `init`(description: Description = ABError().description)
        case from(_ error: Error)
        case `default`
    }

    enum Description {
        case popup(description: Popup = .init())
        case notification(description: Notification)
        case status(description: Status)

        class Popup {
            private static let minButtonCount = 1
            private static let maxButtonCount = 2

            var icon: UIImage
            var description: String
            var buttons: [ButtonType]

            enum ButtonType {
                case gotIt
                case tryAgain
                case lastAccesses
                case call

                var value: String {
                    switch self {
                    case .gotIt:        return R.string.localization.shared_aberror_got_it.localized()
                    case .tryAgain:     return R.string.localization.shared_aberror_try_again.localized()
                    case .lastAccesses: return R.string.localization.shared_aberror_last_accesses.localized()
                    case .call:         return R.string.localization.shared_aberror_call.localized()
                    }
                }
            }

            init(
                icon: UIImage = R.image.deposit.add_card_red()!,
                description: String = R.string.localization.shared_aberror_default_description.localized(),
                buttons: [ButtonType] = [.gotIt]
            ) {
                guard buttons.count >= Popup.minButtonCount,
                      buttons.count <= Popup.maxButtonCount,
                      Set(buttons).count == buttons.count
                else {
                    fatalError("Button count must be more than or equal to \(Popup.minButtonCount) and less than or equal to \(Popup.maxButtonCount) and all elements must be unique")
                }
                self.icon = icon
                self.description = description
                self.buttons = buttons
            }
        }

        class Notification {
            var icon: UIImage
            var description: String

            init(
                icon: UIImage = R.image.deposit.add_card_red()!,
                description: String = R.string.localization.shared_aberror_default_description.localized()
            ) {
                self.icon = icon
                self.description = description
            }
        }

        class Status {
            var description: String
            var type: Type

            enum `Type` {
                case negative
                case positive
            }

            init(
                description: String = R.string.localization.shared_aberror_default_description.localized(),
                type: Type = .negative
            ) {
                self.description = description
                self.type = type
            }
        }
    }

    init(type: Type = .default) {
        self.type = type
    }
}

extension ABError {
    convenience init?(coreStatusCode: AdjarabetCoreStatusCode) {
        guard coreStatusCode != .STATUS_SUCCESS // TODO: apply correct success condition
        else { return nil }
        let type: Type
        switch coreStatusCode {
        case .OTP_IS_REQUIRED:                            type = .otpIsRequired
        case .ACCOUNT_IS_BLOCKED:                         type = .accountIsBlocked
        case .OLD_AND_NEW_VALUES_MATCH_ERROR:             type = .oldAndNewValuesMatchError
        case .ACCOUNT_NOT_FOUND:                          type = .accountNotFound
        case .OTP_REQUEST_LIMIT_REACHED:                  type = .otpRequestLimitReached
        case .UNABLE_TO_SEND_OTP_TEL_IS_MISSING:          type = .unableToSendOTPTelIsMissing
        case .FAILED_TO_SEND_OTP:                         type = .failedToSendOTP
        case .UNABLE_TO_GENERATE_OTP:                     type = .unableToGenerateOTP
        case .USER_WITH_GIVEN_AUTH_CREDENTIALS_NOT_FOUND: type = .wrongAuthCredentials
        case .IP_IS_BLOCKED:                              type = .ipIsBlocked
        case .LAST_ACCESS_FROM_DIFFERENT_IP:              type = .lastAccessFromDifferentIP
        case .WRONG_REQUEST:                              type = .wrongRequest
        case .GENERIC_FAILED_ERROR:                       type = .genericError
        case .MISSING_PARAMETERS:                         type = .missingParameters
        case .ORIGIN_DOMAIN_NOT_ALLOWED:                  type = .originDomainNotAllowed
        case .OTP_NOT_FOUND:                              type = .otpNotFound
        default:                                          type = .default
        }
        self.init(type: type)
    }
}

extension ABError {
    convenience init(dataTransferError: DataTransferError) {
        // FIXME: refactor to all cases
        if case .networkFailure(let networkError) = dataTransferError,
           case .notConnected = networkError {
            self.init(type: .notConnected)
        } else {
            self.init(type: .default)
        }
    }
}

extension ABError: LocalizedError {
    var errorDescription: String? {
        switch description {
        case .popup(let description):        return description.description
        case .notification(let description): return description.description
        case .status(let description):       return description.description
        }
    }
}
