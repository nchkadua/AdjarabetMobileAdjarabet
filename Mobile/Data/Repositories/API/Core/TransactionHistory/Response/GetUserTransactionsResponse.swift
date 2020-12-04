//
//  GetUserTransactionsResponse.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class GetUserTransactionsResponse: DataTransferResponse {
    //    public typealias Body = [BodyEntity] // TODO: proper naming

    struct UsersTransaction: Codable {
        public let id: String?
        public let userAccountId: Int?
        public let amount: Double?
        public let bonusAwardID: Int?
        public let bonusLockedAmount: Double?
        public let bonusAmount: Double?
        public let providerName: String?
        public let transactionStatus: Int?
        public let providerType: Int?
        public let feePercentage: Double?
        public let feeAmount: Double?
        public let totalAmount: Double?
        public let providerUserID: String?
        public let providerServiceID: Int?
        public let exchangeRate: Double?
        public let groupId: String?
        public let dateCreated: String?
        public let dateModified: String?
        public let isRoot: Bool?
        public let channelType: Int?
        public let providerOppCode: String?
//        public let providerReferenceID: Int?

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case userAccountId = "UserAccountId"
            case amount = "Amount"
            case bonusAwardID = "BonusAwardID"
            case bonusLockedAmount = "BonusLockedAmount"
            case bonusAmount = "BonusAmount"
            case providerName = "ProviderName"
            case transactionStatus = "TransactionStatus"
            case providerType = "ProviderType"
            case feePercentage = "TxFeePercentage"
            case feeAmount = "TxFeeAmount"
            case totalAmount = "TotalAmount"
            case providerUserID = "ProviderUserID"
            case providerServiceID = "ProviderServiceID"
            case exchangeRate = "ExchangeRate"
            case groupId = "GroupID"
            case dateCreated = "DateCreated"
            case dateModified = "DateModified"
            case isRoot = "IsRoot"
            case channelType = "ChannelType"
            case providerOppCode = "ProviderOppCode"
//            case providerReferenceID = "ProviderTxReferenceID"
        }
    }

    public struct Body: Codable {
        let statusCode: Int
        let usersTransactions: [UsersTransaction]

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case usersTransactions = "UsersTransactions"
        }
    }

    public typealias Entity = [TransactionHistoryEntity]

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity {
        body.usersTransactions.map { TransactionHistoryEntity(totalAmount: $0.amount,
                                                              date: $0.dateCreated ?? "",
                                                              feeAmount: $0.feeAmount,
                                                              providerName: $0.providerName ?? ""
        ) }
    }
}
