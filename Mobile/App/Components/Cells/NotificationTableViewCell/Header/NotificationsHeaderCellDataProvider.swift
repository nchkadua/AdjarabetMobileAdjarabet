//
//  NotificationsHeaderCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol NotificationsHeaderCellDataProvider: NotificationsHeaderComponentViewModel, StaticHeightDataProvider { }

public extension NotificationsHeaderCellDataProvider {
    var identifier: String { NotificationsHeaderCell.identifierValue }
}

extension DefaultNotificationsHeaderComponentViewModel: NotificationsHeaderCellDataProvider {
}

public extension NotificationsHeaderCellDataProvider {
    var height: CGFloat {
        get {
            44
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
