//
//  TransactionFilterTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol TransactionFilterTableViewCellDataProvider: TransactionFilterComponentViewModel, StaticHeightDataProvider { }

public extension TransactionFilterTableViewCellDataProvider {
    var identifier: String { TransactionFilterTableViewCell.identifierValue }
    var height: CGFloat {
        get { 75 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultTransactionFilterComponentViewModel: TransactionFilterTableViewCellDataProvider { }
