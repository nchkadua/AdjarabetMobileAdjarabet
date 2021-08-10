//
//  SessionManagementRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol SessionManagementRepository {
    @discardableResult
    func aliveSession<T: HeaderProvidingCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
}
