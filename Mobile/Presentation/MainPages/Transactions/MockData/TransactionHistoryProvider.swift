//
//  TransactionHistoryProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

struct TransactionHistoryProvider {
    public static let MockTransactions: [TransactionHistory] =
        [
            TransactionHistory(title: "თიბისი ბანკი",
                               subtitle: "შემოტანა",
                               amount: "+ ₾ 10.00",
                               icon: R.image.transactionsHistory.deposit()!,
                               details: TransactionDetail.TransactionDetailMock
            ),
            TransactionHistory(title: "თიბისი ბანკი",
                               subtitle: "გატანა",
                               amount: "- ₾ 20.00",
                               icon: R.image.transactionsHistory.withdraw()!,
                               details: TransactionDetail.TransactionDetailMock
            ),
            TransactionHistory(title: "საქართველოს ბანკი",
                               subtitle: "შემოტანა",
                               amount: "+ ₾ 150.00",
                               icon: R.image.transactionsHistory.deposit()!,
                               details: TransactionDetail.TransactionDetailMock
            ),
            TransactionHistory(title: "საქართველოს ბანკი",
                               subtitle: "გატანა",
                               amount: "- ₾ 550.00",
                               icon: R.image.transactionsHistory.withdraw()!,
                               details: TransactionDetail.TransactionDetailMock
            ),
            TransactionHistory(title: "VTB",
                               subtitle: "გატანა",
                               amount: "- ₾ 150.00",
                               icon: R.image.transactionsHistory.withdraw()!,
                               details: TransactionDetail.TransactionDetailMock
            ),
            TransactionHistory(title: "VTB ბანკი",
                               subtitle: "შემოტანა",
                               amount: "+ ₾ 350.00",
                               icon: R.image.transactionsHistory.deposit()!,
                               details: TransactionDetail.TransactionDetailMock
            )
        ]
    public static let MockTransactionHeaders: [TransactionHistoryHeader] =
        [
            TransactionHistoryHeader(title: "დღეს განხორციელებული"),
            TransactionHistoryHeader(title: "11 ოქტომბერი"),
            TransactionHistoryHeader(title: "4 ივნისი")
        ]
}

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
    public static let TransactionDetailMock: [TransactionDetail] =
        [
            TransactionDetail(title: "დრო", description: "14:33:32"),
            TransactionDetail(title: "ჯამური თანხა", description: "25.00 $"),
            TransactionDetail(title: "გადახდის ტიპი", description: "DEPOSIT"),
            TransactionDetail(title: "გადახდის პროვაიდერი", description: "TBC")
        ]
}
