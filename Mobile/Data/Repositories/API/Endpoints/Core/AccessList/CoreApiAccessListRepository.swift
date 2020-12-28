//
//  CoreApiAccessListRepository.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class CoreApiAccessListRepository {
    public static let shared = CoreApiAccessListRepository()
    @Inject public var userSession: UserSessionServices
    @Inject public var dataTransferService: DataTransferService
    private var requestBuilder: AdjarabetCoreClientRequestBuilder { AdjarabetCoreClientRequestBuilder() }
    private init() {}
}

extension CoreApiAccessListRepository: AccessListRepository {
    public func getAccessList(params: GetAccessListParams, completion: @escaping GetAccessListCompletion) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            // TODO: completion(.failure("no session id or user id found"))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .set(method: .accessList)
            .set(userId: userId)
            .set(fromDate: params.fromDate, toDate: params.toDate)
            .build()

        dataTransferService.performTask(expecting: GetAccessListResponse.self,
                                        request: request, respondOnQueue: .main, completion: completion)
    }
}
