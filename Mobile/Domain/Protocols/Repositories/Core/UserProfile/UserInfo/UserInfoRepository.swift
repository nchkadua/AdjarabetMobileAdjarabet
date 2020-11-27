//
//  UserInfoRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol UserInfoRepository: UserInfoReadableRepository,
                                    UserInfoWritableRepository { }

// MARK: - Readable Repository
public protocol UserInfoReadableRepository {
    /**
     Returns information about current loged user
     */
    typealias CurrentUserInfoHandler = (Result<UserInfoEntity, Error>) -> Void
    func currentUserInfo(params: CurrentUserInfoParams, completion: @escaping CurrentUserInfoHandler)
}

// for currentUserInfo
public struct CurrentUserInfoParams { }

// MARK: - Writable Repository
public protocol UserInfoWritableRepository { }
