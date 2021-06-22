//
//  CoreApiRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol CoreApiRepository {
    // common properties
    var userSession: UserSessionServices { get }
    var requestBuilder: CoreRequestBuilder { get }
    var dataTransferService: DataTransferService { get }
    // helpers
    var initialRequestBuilder: Result<CoreRequestBuilder, ABError> { get }
    func performTask<Response: CoreDataTransferResponse>(
        expecting responseType: Response.Type,
        completion: @escaping (Result<Response.Entity, ABError>) -> Void,
        requestFiller: (CoreRequestBuilder) -> CoreRequestBuilder
    )
}

extension CoreApiRepository {
    /**
     Default properties
     Implementer can override on desire
     */
    var userSession: UserSessionServices { UserSession.current }
    var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
    var dataTransferService: DataTransferService { DefaultDataTransferService() }

    /**
     Creates requestBuilder and fills with common parameters
     Implementer could use this helper on desire
     */
    var initialRequestBuilder: Result<CoreRequestBuilder, ABError> {
        // create CoreRequestBuilder
        var requestBuilder = self.requestBuilder

        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            return .failure(.sessionNotFound)
        }

        requestBuilder = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .userId, value: "\(userId)")

        return .success(requestBuilder)
    }

    /**
     Performs task in standart way
     Implementer could use this helper on desire
     */
    func performTask<Response: DataTransferResponse>(
        expecting responseType: Response.Type,
        completion: @escaping (Result<Response.Entity, ABError>) -> Void,
        requestFiller: (CoreRequestBuilder) -> CoreRequestBuilder
    ) {
        switch initialRequestBuilder {
        case .success(let requestBuilder):

            let request = requestFiller(requestBuilder)
                .build()

            dataTransferService.performTask(expecting: responseType,
                                            request: request,
                                            respondOnQueue: .main,
                                            completion: completion)

        case .failure(let error): completion(.failure(error))
        }
    }
}
