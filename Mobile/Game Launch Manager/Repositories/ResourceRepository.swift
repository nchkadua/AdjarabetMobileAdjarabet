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
     Load Game Bundle specified by Game Identifier
     */
    // output
    typealias LoadHandler = (Result<Void, Error>) -> Void
    // input
    func load(identifier: GameIdentifier, handler: @escaping LoadHandler)

    /**
     Extracts already loaded Game Bundle specified by Game Identifier
     Returns Path of extracted archive (prefix of Final URL)
     */
    // output
    typealias PathHandler = (Result<(String, String), Error>) -> Void
    // input
    func extract(identifier: GameIdentifier, handler: @escaping PathHandler)

    /**
     Wrapper for loading and extracting the game resources
     */
    func loadAndExtract(identifier: GameIdentifier, handler: @escaping PathHandler)
}

// MARK: - Default Implementation of ResourceRepository
struct DefaultResourceRepository: ResourceRepository {
    let odrManager = ODRManager.shared
    let fileExtractor = FileExtractor.shared

    func load(identifier: GameIdentifier, handler: @escaping LoadHandler) {
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

    func extract(identifier: GameIdentifier, handler: @escaping PathHandler) {
        let fileName = identifier.description.fileName
        fileExtractor.extractFileWithName(fileName) { result in
            switch result {
            case .success(let path):
                handler(.success(path))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    func loadAndExtract(identifier: GameIdentifier, handler: @escaping PathHandler) {
        load(identifier: identifier) { result in
            switch result {
            case .success:
                extract(identifier: identifier, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
