//
//  GetUserTransactionsResponse.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

struct GetUserTransactionsResponse: CoreDataTransferResponse {
    struct UsersTransaction: Codable {
        let amount: Double?
        let providerName: String?
        let feeAmount: Double?
        let dateCreated: String?
     // let id: String?
     // let userAccountId: Int?
     // let bonusAwardID: Int?
     // let bonusLockedAmount: Double?
     // let bonusAmount: Double?
     // let transactionStatus: Int?
     // let providerType: Int?
     // let feePercentage: Double?
     // let totalAmount: Double?
     // let providerUserID: String?
     // let providerServiceID: Int?
     // let exchangeRate: Double?
     // let groupId: String?
     // let dateModified: String?
     // let isRoot: Bool?
     // let channelType: Int?
     // let providerOppCode: String?
     // let providerReferenceID: Int?

        enum CodingKeys: String, CodingKey {
            case amount = "Amount"
            case providerName = "ProviderName"
            case feeAmount = "TxFeeAmount"
            case dateCreated = "DateCreated"
         // case id = "ID"
         // case userAccountId = "UserAccountId"
         // case bonusAwardID = "BonusAwardID"
         // case bonusLockedAmount = "BonusLockedAmount"
         // case bonusAmount = "BonusAmount"
         // case transactionStatus = "TransactionStatus"
         // case providerType = "ProviderType"
         // case feePercentage = "TxFeePercentage"
         // case totalAmount = "TotalAmount"
         // case providerUserID = "ProviderUserID"
         // case providerServiceID = "ProviderServiceID"
         // case exchangeRate = "ExchangeRate"
         // case groupId = "GroupID"
         // case dateModified = "DateModified"
         // case isRoot = "IsRoot"
         // case channelType = "ChannelType"
         // case providerOppCode = "ProviderOppCode"
         // case providerReferenceID = "ProviderTxReferenceID"
        }
    }

    struct Body: CoreStatusCodeable {
        let statusCode: Int
        let usersTransactions: [UsersTransaction]

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case usersTransactions = "UsersTransactions"
        }
    }

    typealias Entity = [TransactionHistoryEntity]

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        let dateFormatter = ABDateFormater(with: .verbose)
        return .success(body.usersTransactions.compactMap {
            TransactionHistoryEntity(totalAmount: $0.amount,
                                     date: dateFormatter.date(from: $0.dateCreated ?? ""),
                                     feeAmount: $0.feeAmount,
                                     providerName: $0.providerName
            ) }
        )
    }
}
