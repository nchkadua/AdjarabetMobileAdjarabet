//
//  TBCRegularPaymentsEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct TBCRegularPaymentsInitDepositEntity {
    public let message: String?
    public let code: Int?
    public let sessionId: String?
}

public struct TBCRegularPaymentsDepositEntity {
    public let message: String?
    public let code: Int?
    public let url: String?
    public let transId: String?
}
