//
//  BalanceManagementRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol BalanceManagementRepository {
    @discardableResult
    func balance<T: HeaderProvidingCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}
