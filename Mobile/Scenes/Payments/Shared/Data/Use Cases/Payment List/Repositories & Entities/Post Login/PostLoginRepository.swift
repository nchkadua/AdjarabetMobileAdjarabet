//
//  PostLoginRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PostLoginRepository {
    /**
     Calls for userLoggedIn Service and
     Returns *some* specifications of user
     For example, Payment Segments ...
     */
    typealias UserLoggedInHandler = (Result<UserLoggedInEntity, ABError>) -> Void
    func userLoggedIn(params: PostLoginRepositoryUserLoggedInParams,
                      handler: @escaping UserLoggedInHandler)
}

struct PostLoginRepositoryUserLoggedInParams {
    let fromRegistration: Bool
    let domain: String = ".com" // FIXME: [.com, .hy]
    let dateRegistered: String = ""
}

// MARK: - Default Implementation
struct DefaultPostLoginRepository: PostLoginRepository {
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var userAgentProvider: UserAgentProvider
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }

    func userLoggedIn(params: PostLoginRepositoryUserLoggedInParams,
                      handler: @escaping UserLoggedInHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId
        else {
            handler(.failure(.sessionNotFound))
            return
        }

        let headers = [ // TODO: Filter headers
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "en-US,en;q=0.9",
            "Connection": "keep-alive",
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "sec-ch-ua": "\"Chromium\";v=\"88\", \"Google Chrome\";v=\"88\", \";Not A Brand\";v=\"99\"", // FIXME: delete?
            "sec-ch-ua-mobile": "?0",
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-site",
            "User-Agent": userAgentProvider.userAgent
        ]

        let body = [
            "user_id": "\(userId)",
            "from_registration": "\(params.fromRegistration)",
            "CurrencyID": "\(currencyId)",
            "domain": params.domain,
            "DateRegistered": params.dateRegistered
        ]

        let request = httpRequestBuilder
            .set(host: "https://webapi-personal.adjarabet.com")
            .set(path: "userLoggedIn")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .set(body: body)
            .build()

        dataTransferService.performTask(expecting: UserLoggedInDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
