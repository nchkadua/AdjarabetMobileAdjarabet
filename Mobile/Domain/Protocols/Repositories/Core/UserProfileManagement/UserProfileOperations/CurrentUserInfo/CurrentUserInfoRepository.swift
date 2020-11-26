//
//  CurrentUserInfoRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol CurrentUserInfoRepository: CurrentUserInfoReadableRepository,
                                           CurrentUserInfoWritableRepository { }

// MARK: - Readable Repository
public protocol CurrentUserInfoReadableRepository {
    /**
     Returns information about current loged user
     */
    @discardableResult
    func currentUserInfo<T: HeaderProvidingCodableType>(
        params: CurrentUserInfoParams,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable?
}

// for currentUserInfo
public struct CurrentUserInfoParams { }

// MARK: - Writable Repository
public protocol CurrentUserInfoWritableRepository { }
