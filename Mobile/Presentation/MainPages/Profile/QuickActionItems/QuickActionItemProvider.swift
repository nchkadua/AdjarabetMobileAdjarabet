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
            QuickAction(icon: R.image.components.quickAction.deposit()!, title: R.string.localization.deposit_button_title(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.withdraw()!, title: R.string.localization.withdraw_button_title(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.transaction_history()!, title: R.string.localization.transaction_history(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.my_cards()!, title: R.string.localization.my_cards(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.my_bonuses()!, title: R.string.localization.my_bonuses(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.balance_management()!, title: R.string.localization.balance_management(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.transfer()!, title: R.string.localization.transfer_to_a_friend(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.incognito()!, title: R.string.localization.incognito_card(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.account()!, title: R.string.localization.account_information(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.parameters()!, title: R.string.localization.account_parameters(), hidesSeparator: false),
            QuickAction(icon: R.image.components.quickAction.logout()!, title: R.string.localization.log_out(), hidesSeparator: true)
        ]
    }
}

public struct QuickAction {
    public var icon: UIImage
    public var title: String
    public var hidesSeparator: Bool
}
