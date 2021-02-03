//
//  StandartGameLaunchUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**

 Responsibilities of Standart Game Launch Use Case
 * Assemble all Repositories (Singular API calls, ODR ...) to assemble Final result
   1. Fetches Service Auth Token for fetching Web URL --- using Signular API call
   2. Fetches Web URL (suffix of Final URL) --- using Signular API call
   3. Fetches Game Bundle archive --- using Resource Repository (ODR)
   4. Extracts fetched Game Bundle archive and gets Path of extracted archive (prefix of Final URL) -- using ResourceRepository (File Extractor)
   5. Assembles Final URL with extracted Game Bundle Path and Web URL
   6. Starts Local Web Server -- TODO
   7. Returns Final URL and Standart Game Launch Garbage Collector (for freeing Resources and other Clean Up)

 */

protocol StandartGameLaunchUseCase {
    // input
    typealias UrlHandler = (Result<GameLaunchUrlResult, Error>) -> Void
    // output
    func launch(gameId: String, providerId: String, handler: @escaping UrlHandler)
}

// MARK: - Default Implementation of StandartGameLaunchUseCase

struct DefaultStandartGameLaunchUseCase: StandartGameLaunchUseCase {

    let webUrlRepo: LaunchUrlRepository = DefaultLaunchUrlRepository()
    let resRepo: ResourceRepository = DefaultResourceRepository()

    func launch(gameId: String, providerId: String, handler: @escaping UrlHandler) {
        //
    }
}

struct StandartGameLaunchGarbageCollector: GameLaunchGarbageCollector {

    func free() {
        //
    }
}
