//
//  TransactionHistoryHeaderCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol TransactionHistoryHeaderCellDataProvider: TransactionHistoryHeaderComponentViewModel,
                                                          StaticHeightDataProvider {}
public extension TransactionHistoryHeaderCellDataProvider {
    var identifier: String {TransactionHistoryHeaderCell.identifierValue }
    var height: CGFloat {
        get { 36 }
        set { print(newValue)}
    }
    var isHeightSet: Bool { true }
}

extension DefaultTransactionHistostoryHeaderComponentViewModel: TransactionHistoryHeaderCellDataProvider {}
