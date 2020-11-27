//
//  UserProfileRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol UserProfileRepository: UserProfileReadableRepository,
                                       UserProfileWritableRepository { }

// MARK: - Readable Repository
public protocol UserProfileReadableRepository: UserInfoReadableRepository { }

// MARK: - Writable Repository
public protocol UserProfileWritableRepository: UserInfoWritableRepository { }
