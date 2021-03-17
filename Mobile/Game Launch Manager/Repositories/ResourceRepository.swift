//
//  ResourceRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/3/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 Repository for managing Resources
 */
protocol ResourceRepository {
    /**
     Wrapper for loading and extracting the game resources
     */
    // output
    typealias PathHandler = (Result<(String, String), Error>) -> Void
    // input
    func loadAndExtract(identifier: GameIdentifier, handler: @escaping PathHandler)
}

// MARK: - Default Implementation of ResourceRepository
struct DefaultResourceRepository: ResourceRepository {
    let odrManager = ODRManager.shared
    let fileExtractor = FileExtractor.shared

    func loadAndExtract(identifier: GameIdentifier, handler: @escaping PathHandler) {
        load(identifier: identifier) { result in
            switch result {
            case .success:
                extract(identifier: identifier, handler: handler)
            case .failure(let error):
                DispatchQueue.main.async { handler(.failure(error)) }
            }
        }
    }

    /**
     Load Game Bundle specified by Game Identifier
     */
    // output
    typealias LoadHandler = (Result<Void, Error>) -> Void
    // input
    private func load(identifier: GameIdentifier, handler: @escaping LoadHandler) {
        let tag = identifier.description.tag
        odrManager.loadResourcesWithTags([tag]) { result in
            switch result {
            case .success:
                handler(.success(()))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    /**
     Extracts already loaded Game Bundle specified by Game Identifier
     Returns Path of extracted archive (prefix of Final URL)
     */
    // input
    private func extract(identifier: GameIdentifier, handler: @escaping PathHandler) {
        let fileName = identifier.description.fileName
        fileExtractor.extractFileWithName(fileName) { result in
            switch result {
            case .success(let path):
                DispatchQueue.main.async { handler(.success(path)) }
            case .failure(let error):
                DispatchQueue.main.async { handler(.failure(error)) }
            }
        }
    }
}
