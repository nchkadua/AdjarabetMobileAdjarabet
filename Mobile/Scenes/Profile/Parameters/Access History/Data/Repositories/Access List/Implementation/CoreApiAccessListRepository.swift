//
//  CoreApiAccessListRepository.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiAccessListRepository: CoreApiRepository { }

extension CoreApiAccessListRepository: AccessListRepository {
    func getAccessList(params: GetAccessListParams, completion: @escaping GetAccessListCompletion) {
        performTask(expecting: GetAccessListResponse.self, completion: completion) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getAccessList")
                .setBody(key: .fromDate, value: params.fromDate)
                .setBody(key: .toDate, value: params.toDate)
        }
    }
}
