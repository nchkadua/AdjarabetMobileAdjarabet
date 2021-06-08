//
//  TransactionDetailsDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol TransactionDetailsTableViewCellDataProvider: TransactionDetailsComponentViewModel, StaticHeightDataProvider { }

public extension TransactionDetailsTableViewCellDataProvider {
    var identifier: String { TransactionDetailsTableViewCell.identifierValue }
    var height: CGFloat {
        get { 36 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultTransactionDetailsComponentViewModel: TransactionDetailsTableViewCellDataProvider { }
