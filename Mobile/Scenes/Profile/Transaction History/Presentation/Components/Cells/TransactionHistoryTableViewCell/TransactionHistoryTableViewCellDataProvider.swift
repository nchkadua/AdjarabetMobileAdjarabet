//
//  TransactionHistoryTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol TransactionHistoryTableViewCellDataProvider: AppCellDelegate,
                                                             TransactionHistoryComponentViewModel,
                                                             StaticHeightDataProvider {}

public extension TransactionHistoryTableViewCellDataProvider {
    var identifier: String { TransactionHistoryTableViewCell.identifierValue }
    var height: CGFloat {
        get { 75 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultTransactionHistoryComponentViewModel: TransactionHistoryTableViewCellDataProvider {}
