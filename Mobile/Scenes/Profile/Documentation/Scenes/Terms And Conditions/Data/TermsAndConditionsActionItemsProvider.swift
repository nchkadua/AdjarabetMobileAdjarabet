//
//  TermsAndConditionsActionItemsProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 02.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class TermsAndConditionsActionItemsProvider {
    public static func items() -> [TermsAndConditionsAction] {
        [
            TermsAndConditionsAction(
                title: R.string.localization.terms_and_conditions.localized(),
                destination: .termsAndConditions),
            TermsAndConditionsAction(
                title: R.string.localization.fair_game_agreement.localized(),
                destination: .fairGameAgreement),
            TermsAndConditionsAction(
                title: R.string.localization.responsible_gaming_policy.localized(),
                destination: .responsibleGamingPolicy),
            TermsAndConditionsAction(
                title: R.string.localization.sport.localized(),
                destination: .sport),
            TermsAndConditionsAction(
                title: R.string.localization.gambling.localized(),
                destination: .gambling),
            TermsAndConditionsAction(
                title: R.string.localization.slots.localized(),
                destination: .slots),
            TermsAndConditionsAction(
                title: R.string.localization.live_casino.localized(),
                destination: .liveCasino),
            TermsAndConditionsAction(
                title: R.string.localization.bura.localized(),
                destination: .bura),
            TermsAndConditionsAction(
                title: R.string.localization.seka.localized(),
                destination: .seka),
            TermsAndConditionsAction(
                title: R.string.localization.domino.localized(),
                destination: .domino)
        ]
    }
}

public struct TermsAndConditionsAction {
    public var title: String
    public var destination: TermsAndConditionsDestination
}

public enum TermsAndConditionsDestination {
    case termsAndConditions
    case fairGameAgreement
    case responsibleGamingPolicy
    case sport
    case gambling
    case slots
    case liveCasino
    case bura
    case seka
    case domino
}
