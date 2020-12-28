//
//  AdjarabetWebAPIClient+AdjarabetWebAPIUserLoggedInServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

extension AdjarabetWebAPIClient: AdjarabetWebAPIUserLoggedInServices {
    public func userLoggedIn<T: Codable>(userId: Int, domain: String, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) {
        let request = standartRequestBuilder
            .set(method: .userLoggedIn)
            .set(userId: userId, domain: domain)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        performTask(request: request, type: T.self, completion: completion)
    }
}
