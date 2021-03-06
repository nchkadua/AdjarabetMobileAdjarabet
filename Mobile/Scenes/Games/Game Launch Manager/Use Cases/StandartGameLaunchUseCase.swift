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
   1. Loads Game Bundle archive --- using Resource Repository (ODR)
   2. Extracts fetched Game Bundle archive and gets Path of extracted archive (prefix of Final URL) -- using ResourceRepository (File Extractor)
   3. Fetches Service Auth Token for fetching Web URL --- using Signular API call
   4. Fetches Web URL (suffix of Final URL) --- using Signular API call
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

        // 1. Load Game Bundle archive
        // 2. Extract fetched Game Bundle archive and get Path of extracted archive
        resRepo.loadAndExtract(identifier: identifier) { result in
            switch result {
            case .success((let root, let gameDir)):
                handleResPath(root, gameDir, gameId, providerId, identifier, handler) // Continue the flow here ...
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func handleResPath(_ root: String,
                               _ gameDir: String,
                               _ gameId: String,
                               _ providerId: String,
                               _ identifier: GameIdentifier,
                               _ handler: @escaping UrlHandler) {
        // 3. Fetch Service Auth Token
        // 4. Fetch Web URL
        webUrlRepo.url(gameId: gameId, providerId: providerId) { result in
            switch result {
            case .success(let webUrl):
                handlePaths(root, gameDir, identifier, webUrl, handler) // Continue the flow here ...
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func handlePaths(_ root: String,
                             _ gameDir: String,
                             _ identifier: GameIdentifier,
                             _ webUrl: String,
                             _ handler: @escaping UrlHandler) {
        // Create final URL object
        guard let finalUrl = URL(string: webUrl)
        else {
            handler(.failure(AdjarabetCoreClientError.coreError(description: "Could not specify the URL")))
            return
        }

        let gameBundlepath = "\(root)/\(gameDir)"
        let path = "file://\(gameBundlepath)/"

        do {
            let fileManager = FileManager()
            try fileManager.createSymbolicLink(at: URL(string: "\(path)hybrid/games/")!, withDestinationURL: URL(string: "\(path)games/")!)
        } catch {
            handler(.failure(AdjarabetCoreClientError.coreError(description: "Could not create Symbolic Link")))
            return
        }

        let caCertificateURL = Bundle.main.url(forResource: "ca", withExtension: "der")!
        let caCertificate = Certificate(derURL: caCertificateURL)!

        let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12")!
        let identity = CertificateIdentity(p12URL: identityURL, passphrase: "test")!

        let webServer = Server(identity: identity, caCertificates: [caCertificate])

        webServer.serveDirectory(URL(string: path)!, "")
        try? webServer.start(port: 8080, interface: "localhost")

        handler(.success(.init(url: finalUrl, gc: StandartGameLaunchGarbageCollector(webServer: webServer, dir: root))))
    }
}

struct StandartGameLaunchGarbageCollector: GameLaunchGarbageCollector {
    let webServer: Server
    let dir: String
    let fileExtractor: FileExtractor = .shared

    func free() {
        webServer.stop(immediately: true)
        fileExtractor.clearUnzippedResourcesFolder(named: dir)
    }
}
