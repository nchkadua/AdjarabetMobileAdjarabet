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
    func token(params: LaunchUrlRepositoryTokenParams, handler: @escaping TokenHandler)

    /**
     Returns Web URL
     specified by already fetched Service Auth Token and gameId
     */
    // ouput
    typealias UrlHandler = (Result<String, Error>) -> Void
    // input
    func url(params: LaunchUrlRepositoryUrlParams, handler: @escaping UrlHandler)
}

/**
 Token Parameters Struct
 */
struct LaunchUrlRepositoryTokenParams {
    let providerId: String
}

/**
 Url Paramters Struct
 */
struct LaunchUrlRepositoryUrlParams {
    let token: String
    let gameId: String
}

// MARK: - Default Implementation of LaunchUrlRepository

struct DefaultLaunchUrlRepository: LaunchUrlRepository, CoreApiRepository {

    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var userAgentProvider: UserAgentProvider

    func token(params: LaunchUrlRepositoryTokenParams, handler: @escaping TokenHandler) {
        performTask(expecting: ServiceAuthTokenDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getServiceAuthToken")
                .setBody(key: "providerID", value: params.providerId)
        }
    }

    func url(params: LaunchUrlRepositoryUrlParams, handler: @escaping UrlHandler) {

        guard let sessionId = userSession.sessionId else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        // TODO: filter headers
        let headers = [
            "accept": "application/json",
            "accept-language": "en-US,en;q=0.9,ru;q=0.8",
            "authorization": "Token e07c52c91add965f9b10383c04b13678",
            "connection": "keep-alive",
            "content-type": "application/json",
            "origin": "https://app.mocklab.io",
            "referer": "https://app.mocklab.io/",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-site",
            "user-agent": userAgentProvider.userAgent,
            "Cookie": sessionId,
            "Accept": "*/*",
        ]

        let body: [String: Any] = [
            "token": params.token,
            "lang": "en",            // FIXME: fix with correct language
            "gameId": params.gameId,
            "channel": 2,
            "demo": false,           // TODO: filter
            "provider": "EGT",       // TODO: filter
            "exitUrl": "test.com",   // TODO: filter
            "launchParameters": [    // TODO: filter
              "gameId": "532_Portal" // TODO: filter
            ]
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
}
