//
//  GameLaunchInteractor.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**

 Responsibilities of Interactor
 * Determination of which UseCase to use
 * Assemble UseCases for Final Result for User

 */

protocol GameLaunchInteractor {
    /**
     Returns Final URL for launching game
     specified by gameId and providerId
     User should just load it in WebView
     */
    // output
    typealias UrlHandler = (Result<GameLaunchUrlResult, Error>) -> Void
    // input
    func launch(gameId: String, handler: @escaping UrlHandler)
    /// add new functions if needed ...
}

/**
 Game Launch Url Result Struct
 */
struct GameLaunchUrlResult {
    let url: URL
    let gc: GameLaunchGarbageCollector
}

/**
 Used by user for
 cleaning Game Resources and
 other cleaning operations
 after closing game
 */
protocol GameLaunchGarbageCollector {
    func free()
}

// MARK: - Default Implementation of GameLaunchInteractor

struct DefaultGameLaunchInteractor: GameLaunchInteractor {
    // Use Case
    let standart: StandartGameLaunchUseCase = DefaultStandartGameLaunchUseCase()

    func launch(gameId: String, handler: @escaping UrlHandler) {
        // assumption: every game launches in standart way
        standart.launch(gameId: gameId, providerId: "11e7b7ca-14f1-b0b0-88fc-005056adb106", handler: handler)
    }
}
