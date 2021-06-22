//
//  RecentlyPlayedGamesUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol RecentlyPlayedGamesUseCase {
    @discardableResult
    func execute(request: RecentlyPlayedGamesUseCaseRequst, completion: @escaping (Result<Games, Error>) -> Void) -> Cancellable?
}

public final class DefaultRecentlyPlayedGamesUseCase: RecentlyPlayedGamesUseCase {
    @Inject(from: .repositories) private var lobbyGamesRepository: LobbyGamesRepository
    @Inject private var userSession: UserSessionReadableServices

    public func execute(request: RecentlyPlayedGamesUseCaseRequst, completion: @escaping (Result<Games, Error>) -> Void) -> Cancellable? {
        lobbyGamesRepository.recentlyPlayedGames(sessionId: userSession.sessionId ?? "", userId: userSession.userId ?? -1, page: request.page, itemsPerPage: request.itemsPerPage) { (result: Result<JSONMessage<Games>, Error>) in
            switch result {
            case .success(let params):
                completion(.success(params.params))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public struct RecentlyPlayedGamesUseCaseRequst {
    public var page: Int
    public var itemsPerPage: Int
}
