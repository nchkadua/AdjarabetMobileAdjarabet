//
//  GameLauchUrlRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol GameLauchUrlRepository: GameLauchUrlReadableRepository,
                                        GameLauchUrlWritableRepository { }

// MARK: - Readable Repository
public protocol GameLauchUrlReadableRepository {
    /**
     Returns game lauch url
     */
    typealias GameLauchUrlHandler = (Result<GameLaunchUrlEntity, Error>) -> Void
    func launchUrl(params: GameLauchUrlParams, completion: @escaping GameLauchUrlHandler)
}

// for currentUserInfo
public struct GameLauchUrlParams {
    let token: String
}

// MARK: - Writable Repository
public protocol GameLauchUrlWritableRepository { }
