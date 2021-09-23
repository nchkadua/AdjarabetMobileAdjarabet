//
//  BlockedUserNotificationTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 23.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol BlockedUserNotificationTableViewCellDataProvider: BlockedUserNotificationComponentViewModel, StaticHeightDataProvider { }

public extension BlockedUserNotificationTableViewCellDataProvider {
    var identifier: String { BlockedUserNotificationTableViewCell.identifierValue }
    var height: CGFloat {
        get { 36 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultBlockedUserNotificationComponentViewModel: BlockedUserNotificationTableViewCellDataProvider { }
