//
//  GameLaunchRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/10/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol GameLaunchRepository: GameLaunchRedableRepository,
                                      GameLaunchWritableRepository { }

// MARK: - Readable Repository
public protocol GameLaunchRedableRepository {
    typealias AuthTokenHandler = (Result<AuthTokenEntity, Error>) -> Void
    func getServiceAuthToken(params: AuthTokenParams, completion: @escaping AuthTokenHandler)
}

public struct AuthTokenParams {
    let providerId: String
}

// MARK: - Writable Repository
public protocol GameLaunchWritableRepository {
}
