//
//  AccountSecurityMessagesTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AccountSecurityMessagesTableViewCellDataProvider: AccountSecurityMessagesComponentViewModel,
                                                                  StaticHeightDataProvider,
                                                                  AppCellDelegate { }

public extension AccountSecurityMessagesTableViewCellDataProvider {
    var identifier: String { AccountSecurityMessagesTableViewCell.identifierValue }
    var height: CGFloat {
        get { 135 + 10 } // Height + Padding
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultAccountSecurityMessagesComponentViewModel: AccountSecurityMessagesTableViewCellDataProvider { }
