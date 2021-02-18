//
//  StandartGameLaunchUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import Telegraph // Web Server Library

/**

 Responsibilities of Standart Game Launch Use Case
 * Assemble all Repositories (Singular API calls, ODR ...) to assemble Final result
   1. Fetches Service Auth Token for fetching Web URL --- using Signular API call
   2. Fetches Web URL (suffix of Final URL) --- using Signular API call
   3. Fetches Game Bundle archive --- using Resource Repository (ODR)
   4. Extracts fetched Game Bundle archive and gets Path of extracted archive (prefix of Final URL) -- using ResourceRepository (File Extractor)
   5. Assembles Final URL with extracted Game Bundle Path and Web URL
   6. Starts Local Web Server
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

        // Identify the game
        guard let identifier = GameIdentifier(providerId: providerId, gameId: gameId)
        else {
            handler(.failure(AdjarabetCoreClientError.coreError(description: "Could not identify the game")))
            return
        }

        // 1. Fetch Service Auth Token
        // 2. Fetch Web URL
        webUrlRepo.url(gameId: gameId, providerId: providerId) { (result) in
            switch result {
            case .success(let webUrl):
                // Continue the flow here ...
                handleWebUrl(webUrl, identifier, handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func handleWebUrl(_ webUrl: String,
                              _ identifier: GameIdentifier,
                              _ handler: @escaping UrlHandler) {
        // 3. Fetch Game Bundle archive
        // 4. Extract fetched Game Bundle archive and get Path of extracted archive
        resRepo.loadAndExtract(identifier: identifier) { (result) in
            switch result {
            case .success(let gameBundlepath):
                // Continue the flow here ...
                handlePaths(gameBundlepath, webUrl, handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func handlePaths(_ gameBundlepath: String,
                             _ webUrl: String,
                             _ handler: @escaping UrlHandler) {

        DispatchQueue.main.async { // TODO: somehow this is called in background thread

            // Create final URL object
            guard let finalUrl = URL(string: webUrl) // .replacingOccurrences(of: "Singular_NewAPI_stg_Portal_GEL", with: "8181")
            else {
                handler(.failure(AdjarabetCoreClientError.coreError(description: "Could not specify the URL")))
                return
            }

            let path = "file://" + gameBundlepath + "/" + "RORJSlot" + "/"

            let caCertificateURL = Bundle.main.url(forResource: "ca", withExtension: "der")!
            let caCertificate = Certificate(derURL: caCertificateURL)!

            let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12")!
            let identity = CertificateIdentity(p12URL: identityURL, passphrase: "test")!

            let webServer = Server(identity: identity, caCertificates: [caCertificate])

            webServer.serveDirectory(URL(string: path)!, "")
            try! webServer.start(port: 8080, interface: "localhost")

            handler(.success(.init(url: finalUrl, gc: StandartGameLaunchGarbageCollector(webServer: webServer))))
        }
    }
}

struct StandartGameLaunchGarbageCollector: GameLaunchGarbageCollector {

    var webServer: Server

    func free() {
        //
    }
}
