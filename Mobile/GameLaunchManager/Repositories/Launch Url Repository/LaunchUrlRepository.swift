//
//  LaunchUrlRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 Repository for fetching Web URL (suffix of final URL)
 */
protocol LaunchUrlRepository {
    /**
     Returns Service Auth Token
     for later use, for fetching Web URL
     */
    // output
    typealias TokenHandler = (Result<String, Error>) -> Void
    // input
    func token(providerId: String, handler: @escaping TokenHandler)

    /**
     Returns Web URL
     */
    // ouput
    typealias UrlHandler = (Result<String, Error>) -> Void
    // input
    /**
     Specified by already fetched Service Auth Token and gameId
     */
    func url(token: String, gameId: String, handler: @escaping UrlHandler)
    /**
     Wrapper for fetching token and Web URL in one function
     */
    func url(gameId: String, providerId: String, handler: @escaping UrlHandler)
}

// MARK: - Default Implementation of LaunchUrlRepository

struct DefaultLaunchUrlRepository: LaunchUrlRepository, CoreApiRepository {

    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var userAgentProvider: UserAgentProvider

    func token(providerId: String, handler: @escaping TokenHandler) {
        performTask(expecting: ServiceAuthTokenDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getServiceAuthToken")
                .setBody(key: "providerID", value: providerId)
        }
    }

    func url(token: String, gameId: String, handler: @escaping UrlHandler) {

        guard let sessionId = userSession.sessionId else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        // TODO: filter headers
        let headers = [
            "accept": "*/*",
            "accept-language": "en-US,en;q=0.9,ru;q=0.8",
            "connection": "keep-alive",
            "origin": "https://app.mocklab.io",
            "referer": "https://app.mocklab.io/",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-site",
            "user-agent": userAgentProvider.userAgent,
            "Cookie": sessionId
        ]

        let body: [String: Any] = [
            "channel": 2,
            "lang": "en",            // FIXME: fix with correct language
            "gameId": gameId,
            "token": token,
            "exitUrl": "test.com",   // FIXME
            "applicationType": "Android"
        ]

        let request = httpRequestBuilder
            .set(host: "https://siswebapi.adjarabet-stage.com/api/v1/init")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeJson())
            .setBody(json: body)
            .build()

        dataTransferService.performTask(expecting: LaunchUrlDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }

    func url(gameId: String, providerId: String, handler: @escaping UrlHandler) {
        token(providerId: providerId) { (result) in
            switch result {
            case .success(let token):
                url(token: token, gameId: gameId, handler: handler)
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
