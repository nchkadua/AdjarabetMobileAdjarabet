//
//  AccessListRepository.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol AccessListRepository: AccessListRedableRepository,
                                                      AccessListWritableRepository { }

// MARK: - Readable Repository
public protocol AccessListRedableRepository {
    typealias GetAccessListCompletion = (Result<[AccessListEntity], Error>) -> Void
    func getAccessList(params: GetAccessListParams, completion: @escaping GetAccessListCompletion)
}

public struct GetAccessListParams {
    let fromDate: String
    let toDate: String
}

// MARK: - Writable Repository
public protocol AccessListWritableRepository {
}
