//
//  TransactionFilter.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct TransactionTypeManager {
    var dataSource: [TransactionTypeModel] = []

    private var filterState: [TransactionType: Bool] = [
        .all: true,
        .deposit: false,
        .withdraw: false
    ]

    // Refactor using high-order function: firstWhere
    var selectedTransactionType: TransactionType? {
        for (key, value) in filterState where value {
            return key
        }
        return nil
    }

    public init() {
        dataSource.append(TransactionTypeModel(title: "ყველა ტრანზაქცია", checked: filterState[.all]!, transactionType: .all))
        dataSource.append(TransactionTypeModel(title: "შევსება", checked: filterState[.deposit]!, transactionType: .deposit))
        dataSource.append(TransactionTypeModel(title: "გადარიცხვა", checked: filterState[.withdraw]!, transactionType: .withdraw))
    }

    public mutating func setTransaction(type: TransactionType, to isChecked: Bool) {
        // Only one checkbox can be active at a time
        filterState[.all] = false
        filterState[.deposit] = false
        filterState[.withdraw] = false
        if isChecked {
            filterState[type] = isChecked
        }
        dataSource[0].checked = filterState[.all]!
        dataSource[1].checked = filterState[.deposit]!
        dataSource[2].checked = filterState[.withdraw]!
    }
}

public struct TransactionTypeModel {
    public let title: String
    public var checked: Bool = false
    public let transactionType: TransactionType
}

public enum TransactionType: Int {
    case all = 0
    case deposit = 1
    case withdraw = 2
}
