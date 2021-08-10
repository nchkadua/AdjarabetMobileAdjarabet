//
//  RecentlyPlayedGamesUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

protocol RecentlyPlayedGamesUseCase {
    @discardableResult
    func execute(request: RecentlyPlayedGamesUseCaseRequst, completion: @escaping (Result<Games, ABError>) -> Void) -> Cancellable?
}

final class DefaultRecentlyPlayedGamesUseCase: RecentlyPlayedGamesUseCase {
    @Inject(from: .repositories) private var lobbyGamesRepository: LobbyGamesRepository
    @Inject private var userSession: UserSessionReadableServices

    func execute(request: RecentlyPlayedGamesUseCaseRequst, completion: @escaping (Result<Games, ABError>) -> Void) -> Cancellable? {
        lobbyGamesRepository.recentlyPlayedGames(sessionId: userSession.sessionId ?? "", userId: userSession.userId ?? -1, page: request.page, itemsPerPage: request.itemsPerPage) { (result: Result<JSONMessage<Games>, ABError>) in
            switch result {
            case .success(let params):
                completion(.success(params.params))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct RecentlyPlayedGamesUseCaseRequst {
    var page: Int
    var itemsPerPage: Int
}
