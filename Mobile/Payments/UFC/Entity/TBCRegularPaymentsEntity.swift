//
//  TBCRegularPaymentsEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Deposit
public struct TBCRegularPaymentsDepositEntity {
    public let message: String?
    public let code: Int?
    public let url: String?
    public let transId: String?
}

// MARK: Withdraw
public struct TBCRegularPaymentsInitWithdrawEntity {
    public let message: String?
    public let code: Int?
    public let sessionId: String?
    public let fee: Double?
}

public struct TBCRegularPaymentsWithdrawEntity {
    public let message: String?
    public let code: Int?
}
