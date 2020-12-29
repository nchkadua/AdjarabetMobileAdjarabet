//
//  DefaultGameRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DefaultLobbyGamesRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: AdjarabetMobileClientRequestBuilder { AdjarabetMobileClientRequestBuilder() }
}

extension DefaultLobbyGamesRepository: LobbyGamesRepository {
    public func games<T>(sessionId: String, userId: Int, page: Int, itemsPerPage: Int, searchTerm: String?, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Decodable, T: Encodable {
        let request = requestBuilder
            .set(method: .games)
            .set(sessionId: sessionId, userId: userId, page: page, itemsPerPage: itemsPerPage, searchTerm: searchTerm)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func recentlyPlayedGames<T>(sessionId: String, userId: Int, page: Int, itemsPerPage: Int, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Decodable, T: Encodable {
        let request = requestBuilder
            .set(method: .recentlyPlayed)
            .set(sessionId: sessionId, userId: userId, page: page, itemsPerPage: itemsPerPage)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
