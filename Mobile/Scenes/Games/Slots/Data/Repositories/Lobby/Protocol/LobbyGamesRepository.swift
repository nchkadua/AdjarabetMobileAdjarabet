//
//  GameRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol LobbyGamesRepository {
    @discardableResult
    func games<T: Codable>(sessionId: String, userId: Int, page: Int, itemsPerPage: Int, searchTerm: String?, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
    func recentlyPlayedGames<T: Codable>(sessionId: String, userId: Int, page: Int, itemsPerPage: Int, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
}
