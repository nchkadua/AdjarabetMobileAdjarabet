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
struct LaunchUrlRepositoryTokenParams { // FIXME: Fix after reciving doc from Singular
    let providerId: String
}

/**
 Url Paramters Struct
 */
struct LaunchUrlRepositoryUrlParams { // FIXME: Fix after reciving doc from Singular
    let token: String
    let gameId: String
}

// MARK: - Default Implementation of LaunchUrlRepository

struct DefaultLaunchUrlRepository: LaunchUrlRepository {

    func token(params: LaunchUrlRepositoryTokenParams, handler: @escaping TokenHandler) {
        //
    }

    func url(params: LaunchUrlRepositoryUrlParams, handler: @escaping UrlHandler) {
        //
    }
}
