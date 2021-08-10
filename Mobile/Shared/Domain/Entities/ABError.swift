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
        case .ipIsBlocked:
            return .popup(description: .init(icon: .init(), description: "IP Is Blocked")) // TODO: add correct icon and description
        case .wrongAuthCredentials:
            return .notification(description: .init(icon: .init(), description: "Wrong Credentials")) // TODO: add correct icon and description
        case .notConnected:
            return .status(description: .init(description: "Not Connected")) // TODO: add description
        case .`init`(let description):
            return description
        case .from(let error):
            return .popup(description: .init(description: error.localizedDescription))
        default: // also case .default
            return .popup()
        }
    }()

    enum `Type` {
        case ipIsBlocked
        case wrongAuthCredentials
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
            }

            init(
                icon: UIImage = .init(), // TODO: add correct default icon
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
                icon: UIImage = .init(), // TODO: add correct default icon
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
        case .USER_WITH_GIVEN_AUTH_CREDENTIALS_NOT_FOUND: type = .wrongAuthCredentials
        case .IP_IS_BLOCKED:                              type = .ipIsBlocked
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
