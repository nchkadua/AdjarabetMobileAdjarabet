//
//  QuickActionItemProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class QuickActionItemProvider {
    public static func items(_ biometryQuickActionIcon: UIImage) -> [QuickAction] {
        [
            QuickAction(icon: R.image.components.quickAction.deposit()!, title: R.string.localization.deposit_button_title.localized(), destionation: .deposit),
            QuickAction(icon: R.image.components.quickAction.withdraw()!, title: R.string.localization.withdraw_button_title.localized(), destionation: .withdraw),
            QuickAction(icon: R.image.components.quickAction.transaction_history()!, title: R.string.localization.transaction_history.localized(), destionation: .transactionHistory),
            QuickAction(icon: R.image.components.quickAction.my_cards()!, title: R.string.localization.my_cards.localized(), destionation: .myCards),
            QuickAction(icon: biometryQuickActionIcon, title: R.string.localization.biomatry_authentication_parameters.localized(), destionation: .biometryParameters),
            QuickAction(icon: R.image.components.quickAction.faq()!, title: R.string.localization.faq.localized(), destionation: .faq),
            // QuickAction(icon: R.image.components.quickAction.my_bonuses()!, title: R.string.localization.my_bonuses.localized(), destionation: .myBonuses),
            // QuickAction(icon: R.image.components.quickAction.transfer()!, title: R.string.localization.transfer_to_a_friend.localized(), destionation: .transferToFriend),
            // QuickAction(icon: R.image.components.quickAction.incognito()!, title: R.string.localization.incognito_card.localized(), destionation: .incognitoCard),
            QuickAction(icon: R.image.components.quickAction.account_info()!, title: R.string.localization.account_information.localized(), destionation: .accountInformation),
            QuickAction(icon: R.image.components.quickAction.parameters()!, title: R.string.localization.account_parameters.localized(), destionation: .accountParameters),
            QuickAction(icon: R.image.components.quickAction.terms()!, title: R.string.localization.documentation.localized(), destionation: .documentation)
//            QuickAction(icon: R.image.components.quickAction.logout()!, title: R.string.localization.log_out.localized(), hidesSeparator: true, destionation: .loginPage)
        ]
    }
}

public struct QuickAction {
    public var icon: UIImage
    public var title: String
    public var destionation: ProfileNavigator.Destination
}
