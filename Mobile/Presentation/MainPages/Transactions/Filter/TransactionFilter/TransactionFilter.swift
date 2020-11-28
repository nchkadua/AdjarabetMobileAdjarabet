//
//  TransactionFilter.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct TransactionFilters {
    static let filters: [TransactionFilter] = [
        TransactionFilter(title: "ყველა ტრანზაქცია"),
        TransactionFilter(title: "შევსება"),
        TransactionFilter(title: "გადარიცხვა")
    ]
}

public struct TransactionFilter {
    public let title: String
    public var checked: Bool = false
}
