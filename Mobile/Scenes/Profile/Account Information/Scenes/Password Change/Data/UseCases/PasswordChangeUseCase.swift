//
//  PasswordChangeUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/11/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PasswordChangeUseCase {
    typealias PasswordChangeHandler = (Result<PasswordChangeEntity, Error>) -> Void
    func change(oldPassword: String, newPassword: String, handler: @escaping PasswordChangeHandler)
}

struct DefaultPasswordChangeUseCase: PasswordChangeUseCase {
    @Inject(from: .repositories) private var repo: PasswordChangeRepository
    @Inject private var userSession: UserSessionServices
    @Inject private var userSessionReadable: UserSessionReadableServices

    func change(oldPassword: String, newPassword: String, handler: @escaping PasswordChangeHandler) {
        repo.change(params: .init(oldPassword: oldPassword, newPassword: newPassword)) { result in
            switch result {
            case .success(let entity):
                save(password: newPassword)
                handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    private func save(password: String) {
        userSession.set(userId: userSessionReadable.userId ?? -1,
                        username: userSessionReadable.username ?? "",
                        sessionId: userSessionReadable.sessionId ?? "",
                        currencyId: userSessionReadable.currencyId,
                        password: password)
    }
}
