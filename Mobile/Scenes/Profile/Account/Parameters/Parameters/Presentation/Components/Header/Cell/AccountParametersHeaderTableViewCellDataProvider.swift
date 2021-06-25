//
//  AccountParametersHeaderTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AccountParametersHeaderTableViewCellDataProvider: AccountParametersHeaderComponentViewModel, StaticHeightDataProvider { }

public extension AccountParametersHeaderTableViewCellDataProvider {
    var identifier: String { AccountParametersHeaderTableViewCell.identifierValue }
    var height: CGFloat {
        get { 58 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultAccountParametersHeaderComponentViewModel: AccountParametersHeaderTableViewCellDataProvider { }
