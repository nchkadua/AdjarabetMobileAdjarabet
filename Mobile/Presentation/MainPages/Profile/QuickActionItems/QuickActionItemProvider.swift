//
//  QuickActionItemProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class QuickActionItemProvider {
    public static func items() -> [QuickAction] {
        [
            QuickAction(icon: R.image.components.quickAction.deposit()!, title: R.string.localization.deposit_button_title.localized(), hidesSeparator: false, destionation: .deposit, roundedCorners: [.topLeft, .topRight]),
            QuickAction(icon: R.image.components.quickAction.withdraw()!, title: R.string.localization.withdraw_button_title.localized(), hidesSeparator: false, destionation: .withdraw, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.transaction_history()!, title: R.string.localization.transaction_history.localized(), hidesSeparator: false, destionation: .transactionHistory, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.my_cards()!, title: R.string.localization.my_cards.localized(), hidesSeparator: false, destionation: .myCards, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.biometry()!, title: R.string.localization.biomatry_authentication_parameters.localized(), hidesSeparator: false, destionation: .biometryParameters, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.my_bonuses()!, title: R.string.localization.my_bonuses.localized(), hidesSeparator: false, destionation: .myBonuses, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.transfer()!, title: R.string.localization.transfer_to_a_friend.localized(), hidesSeparator: false, destionation: .transferToFriend, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.incognito()!, title: R.string.localization.incognito_card.localized(), hidesSeparator: false, destionation: .incognitoCard, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.account_info()!, title: R.string.localization.account_information.localized(), hidesSeparator: false, destionation: .accountInformation, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.parameters()!, title: R.string.localization.account_parameters.localized(), hidesSeparator: false, destionation: .accountParameters, roundedCorners: []),
            QuickAction(icon: R.image.components.quickAction.logout()!, title: R.string.localization.log_out.localized(), hidesSeparator: true, destionation: .loginPage, roundedCorners: [.bottomLeft, .bottomRight])
        ]
    }
}

public struct QuickAction {
    public var icon: UIImage
    public var title: String
    public var hidesSeparator: Bool
    public var destionation: ProfileNavigator.Destination
    public var roundedCorners: UIRectCorner
}
