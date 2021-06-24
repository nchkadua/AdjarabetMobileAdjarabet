//
//  LogOutTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol LogOutTableViewCellDataProvider: LogOutComponentViewModel, StaticHeightDataProvider { }

public extension LogOutTableViewCellDataProvider {
    var identifier: String { LogOutTableViewCell.identifierValue }
    var height: CGFloat {
        get { 64 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultLogOutComponentViewModel: LogOutTableViewCellDataProvider { }
