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
    private let dayDateFormatter = ABDateFormater(with: .day)
    public func execute(params: DisplayAccessListUseCaseParams,
                        completion: @escaping AccessListUseCaseCompletion) -> Cancellable? {
        // Date Selection in UI is unclisve. Date selection in API is exclusive. We need to add 1 day to to include desired last day
        let endDate = dayDateFormatter.date(from: params.toDate)
        let correctEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)!
        let correctEndDateString = dayDateFormatter.string(from: correctEndDate)
        let requestParams: GetAccessListParams = .init(fromDate: params.fromDate, toDate: correctEndDateString)

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
