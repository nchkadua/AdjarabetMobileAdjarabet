//
//  BalanceTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol BalanceTableViewCellDataProvider: BalanceComponentViewModel, StaticHeightDataProvider { }

public extension BalanceTableViewCellDataProvider {
    var identifier: String { BalanceTableViewCell.identifierValue }
}

extension DefaultBalanceComponentViewModel: BalanceTableViewCellDataProvider { }

public extension DefaultBalanceComponentViewModel {
    var height: CGFloat {
        get {
            210
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
