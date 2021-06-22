//
//  UserInfoRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
protocol UserInfoRepository: UserInfoReadableRepository,
                             UserInfoWritableRepository { }

// MARK: - Readable Repository
protocol UserInfoReadableRepository {
    /**
     Returns information about current loged user
     */
    typealias CurrentUserInfoHandler = (Result<UserInfoEntity, ABError>) -> Void
    func currentUserInfo(params: CurrentUserInfoParams, completion: @escaping CurrentUserInfoHandler)
}

// for currentUserInfo
struct CurrentUserInfoParams { }

// MARK: - Writable Repository
protocol UserInfoWritableRepository { }
