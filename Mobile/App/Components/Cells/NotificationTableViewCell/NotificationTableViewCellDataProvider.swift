//
//  NotificationTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol NotificationTableViewCellDataProvider: AppCellDelegate, NotificationComponentViewModel, StaticHeightDataProvider, AppDeletableCellDelegate { }

public extension NotificationTableViewCellDataProvider {
    var identifier: String { NotificationTableViewCell.identifierValue }
}

extension DefaultNotificationComponentViewModel: NotificationTableViewCellDataProvider { }

public extension NotificationTableViewCellDataProvider {
    var height: CGFloat {
        get {
            100
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
