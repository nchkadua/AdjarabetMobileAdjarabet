//
//  AccessHistoryTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AccessHistoryTableViewCellDataProvider: AccessHistoryComponentViewModel, StaticHeightDataProvider { }

public extension AccessHistoryTableViewCellDataProvider {
    var identifier: String { AccessHistoryTableViewCell.identifierValue }
    var height: CGFloat {
        get { 60 + 10 } // height + padding
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultAccessHistoryComponentViewModel: AccessHistoryTableViewCellDataProvider { }
