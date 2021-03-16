//
//  UFCTransactionRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 General Paramters for UFC Transaction
 */
protocol UFCTransactionParams {

}

protocol UFCDepositRepository {
    /**
     Initializes Deposit Transaction:
     Returns Session ID for Transaction
     */
    // output
    typealias InitDepositHandler = (Result<UFCInitDepositEntity, Error>) -> Void
    // input
    func initDeposit(_ handler: InitDepositHandler)
}
