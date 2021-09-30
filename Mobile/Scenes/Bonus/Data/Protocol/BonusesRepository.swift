//
//  BonusesRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol BonusesRepository {
    typealias ActiveBonusesHandler = (Result<ActiveBonusEntity, ABError>) -> Void
    func getActiveBonuses(pageIndex: Int, handler: @escaping ActiveBonusesHandler)

    typealias CompletedBonusesHandler = (Result<CompletedBonusEntity, ABError>) -> Void
    func getCompletedBonuses(pageIndex: Int, handler: @escaping CompletedBonusesHandler)
}
