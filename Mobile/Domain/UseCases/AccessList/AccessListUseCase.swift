//
//  AccessListUseCase.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Protocol
public protocol DisplayAccessListUseCase {
    typealias AccessListUseCaseCompletion = (Result<[AccessListEntity], Error>) -> Void
    @discardableResult
    func execute(params: DisplayAccessListUseCaseParams,
                 completion: @escaping AccessListUseCaseCompletion) -> Cancellable?
}

public final class DefaultAccessListUseCaseUseCase: DisplayAccessListUseCase {
    @Inject(from: .repositories) private var repository: AccessListRepository
    @Inject private var userSession: UserSessionReadableServices

    public func execute(params: DisplayAccessListUseCaseParams,
                        completion: @escaping AccessListUseCaseCompletion) -> Cancellable? {
        let requestParams: GetAccessListParams = .init(fromDate: params.fromDate, toDate: params.toDate)

        repository.getAccessList(params: requestParams) { result  in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil // TODO??
    }
}

public struct DisplayAccessListUseCaseParams {
    let fromDate: String
    let toDate: String
}
