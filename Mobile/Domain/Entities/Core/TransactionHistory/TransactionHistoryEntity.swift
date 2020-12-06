//
//  TransactionHistoryEntity.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct TransactionHistoryEntity {
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()

    public let totalAmount: Double?
    public let date: Date?
    public let feeAmount: Double?
    public var transactionType: Int?
    public let providerName: String?
    init(totalAmount: Double?, date: String, feeAmount: Double?, providerName: String) {
        self.totalAmount = totalAmount
        self.date = TransactionHistoryEntity.dateFormatter.date(from: date)
        self.feeAmount = feeAmount
        self.providerName = providerName
    }
}
