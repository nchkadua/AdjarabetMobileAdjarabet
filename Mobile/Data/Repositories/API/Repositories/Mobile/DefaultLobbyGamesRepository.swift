//
//  DefaultGameRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DefaultLobbyGamesRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: MobileRequestBuilder { MobileRequestBuilder() }
}

extension DefaultLobbyGamesRepository: LobbyGamesRepository {
    public func games<T>(sessionId: String, userId: Int, page: Int, itemsPerPage: Int, searchTerm: String?, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Decodable, T: Encodable {
        var requestBuilder = self.requestBuilder
            .set(method: .games)
            .setBody(key: .sessionId, value: sessionId)
            .setBody(key: .userId, value: "\(userId)")
            .setBody(key: .page, value: "\(page)")
            .setBody(key: .propousedNumberOfItems, value: "\(itemsPerPage)")

        if let searchTerm = searchTerm {
            requestBuilder = requestBuilder
                .setBody(key: .term, value: searchTerm)
        }

        let request = requestBuilder.build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func recentlyPlayedGames<T>(sessionId: String, userId: Int, page: Int, itemsPerPage: Int, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Decodable, T: Encodable {
        let request = requestBuilder
            .set(method: .recentlyPlayed)
            .setBody(key: .sessionId, value: sessionId)
            .setBody(key: .userId, value: "\(userId)")
            .setBody(key: .page, value: "\(page)")
            .setBody(key: .propousedNumberOfItems, value: "\(itemsPerPage)")
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
