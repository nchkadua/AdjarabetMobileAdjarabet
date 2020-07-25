//
//  LobbyGamesUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/4/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol LobbyGamesUseCase {
    @discardableResult
    func execute(request: LobbyGamesUseCaseRequst, completion: @escaping (Result<Games, Error>) -> Void) -> Cancellable?
}

public final class DefaultLobbyGamesUseCase: LobbyGamesUseCase {
    @Inject(from: .repositories) private var lobbyGamesRepository: LobbyGamesRepository
    @Inject private var userSession: UserSessionReadableServices

    public func execute(request: LobbyGamesUseCaseRequst, completion: @escaping (Result<Games, Error>) -> Void) -> Cancellable? {
        lobbyGamesRepository.games(sessionId: userSession.sessionId ?? "", userId: userSession.userId ?? -1, page: request.page, itemsPerPage: request.itemsPerPage, searchTerm: request.searchTerm) { (result: Result<JSONMessage<Games>, Error>) in
            switch result {
            case .success(let params):
                completion(.success(params.params))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public struct LobbyGamesUseCaseRequst {
    public var page: Int
    public var itemsPerPage: Int
    public var searchTerm: String?
}
