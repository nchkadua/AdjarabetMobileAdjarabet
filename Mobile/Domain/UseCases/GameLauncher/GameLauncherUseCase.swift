//
//  GameLauncherUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol GameLauncherUseCase {
    typealias GameLauncherUseCaseCompletion = (Result<GameLaunchUrlEntity, Error>) -> Void
    func execute(params: GameLauncherUseCaseParams, completion: @escaping GameLauncherUseCaseCompletion)
}

public final class DefaultGameLauncherUseCase: GameLauncherUseCase {
    @Inject(from: .repositories) private var tokenRepository: GameLaunchRepository
    @Inject(from: .repositories) private var launchUrlRepository: GameLauchUrlRepository

    public func execute(params: GameLauncherUseCaseParams, completion: @escaping GameLauncherUseCaseCompletion) {
        tokenRepository.getServiceAuthToken(params: .init(providerId: params.providerId)) { result in
            switch result {
            case .success(let authToken): self.getLaunchUrl(authToken, params, completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    private func getLaunchUrl(_ authToken: AuthTokenEntity, _ params: GameLauncherUseCaseParams, _ completion: @escaping GameLauncherUseCaseCompletion) {
        launchUrlRepository.launchUrl(params: .init(token: authToken.token ?? "")) { result in
            switch result {
            case .success(let launchUrl): completion(.success(launchUrl))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

public struct GameLauncherUseCaseParams {
    let gameId: String
    let providerId: String
}
