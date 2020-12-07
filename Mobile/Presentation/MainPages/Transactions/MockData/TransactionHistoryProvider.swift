//
//  TransactionHistoryProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct TransactionHistory {
    public let title: String
    public let subtitle: String
    public let amount: String
    public let icon: UIImage
    public let details: [TransactionDetail]
}

public struct TransactionHistoryHeader {
    public let title: String
}

public struct TransactionDetail {
    public let title: String
    public let description: String
}

public struct TransactionHistoryFormatter {
    static var detailsDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
}
