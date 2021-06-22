//
//  AccessListRepository.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
protocol AccessListRepository: AccessListRedableRepository,
                               AccessListWritableRepository { }

// MARK: - Readable Repository
protocol AccessListRedableRepository {
    typealias GetAccessListCompletion = (Result<[AccessListEntity], ABError>) -> Void
    func getAccessList(params: GetAccessListParams, completion: @escaping GetAccessListCompletion)
}

struct GetAccessListParams {
    let fromDate: String
    let toDate: String
}

// MARK: - Writable Repository
protocol AccessListWritableRepository { }
