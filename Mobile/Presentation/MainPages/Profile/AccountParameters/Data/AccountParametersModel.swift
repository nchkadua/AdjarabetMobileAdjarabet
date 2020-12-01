//
//  AccountParametersModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

protocol AccountParameterCell {
}

struct AccountParameter: AccountParameterCell {
    let title: String
    let icon: UIImage
    let destination: AccountParametersNavigator.Destination
}

struct AccountParameterHeader: AccountParameterCell {
    let title: String
}

enum AccountParameterMessagesType {
    case sms
    case email
}

struct AccountParameterMessages: AccountParameterCell {
    let title: String
    let description: String
    let buttonTitle: String
    var switchState: Bool
    let type: AccountParameterMessagesType

    mutating func setSwitch(to state: Bool) {
        switchState = state
    }
}

struct AccountParametersModel {
    lazy var dataSource: [AccountParameterCell] = [
        AccountParameter(title: R.string.localization.account_parameters_change_password.localized(),
                         icon: (R.image.accountParameters.changePassword()!.withRenderingMode(.alwaysTemplate)),
                         destination: .changePassword),
        AccountParameter(title: R.string.localization.account_parameters_high_security.localized(),
                         icon: (R.image.accountParameters.highSecurity()!.withRenderingMode(.alwaysTemplate)),
                         destination: .highSecurity),
        AccountParameter(title: R.string.localization.account_parameters_self_block.localized(),
                         icon: (R.image.accountParameters.blockSelf()!.withRenderingMode(.alwaysTemplate)),
                         destination: .blockSelf),
        AccountParameter(title: R.string.localization.account_parameters_login_history.localized(),
                         icon: (R.image.accountParameters.loginHistory()!.withRenderingMode(.alwaysTemplate)),
                         destination: .loginHistory),
        AccountParameterHeader(title: R.string.localization.account_parameters_messages_header.localized()),
        AccountParameterMessages(title: R.string.localization.account_parameters_messages_sms_title.localized(),
                                 description: R.string.localization.account_parameters_messages_sms_description.localized(),
                                 buttonTitle: R.string.localization.account_parameters_messages_sms_button.localized(),
                                 switchState: false,
                                 type: .sms),
        AccountParameterMessages(title: R.string.localization.account_parameters_messages_email_title.localized(),
                                 description: R.string.localization.account_parameters_messages_email_description.localized(),
                                 buttonTitle: R.string.localization.account_parameters_messages_email_button.localized(),
                                 switchState: false,
                                 type: .sms)
    ]
}
