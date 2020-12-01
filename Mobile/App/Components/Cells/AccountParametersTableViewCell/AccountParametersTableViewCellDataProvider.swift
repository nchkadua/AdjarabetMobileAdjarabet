//
//  AccountParametersTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AccountParametersTableViewCellDataProvider: AccountParametersComponentViewModel,
                                                            StaticHeightDataProvider,
                                                            AppCellDelegate { }

public extension AccountParametersTableViewCellDataProvider {
    var identifier: String { AccountParametersTableViewCell.identifierValue }
    var height: CGFloat {
        get { 60 + 10 } // height + padding
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultAccountParametersComponentViewModel: AccountParametersTableViewCellDataProvider { }
