//
//  AccessListUseCase.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Protocol
protocol DisplayAccessListUseCase {
    typealias AccessListUseCaseCompletion = (Result<[AccessListEntity], ABError>) -> Void
    @discardableResult
    func generateRequestParams(from useCaseParams: DisplayAccessListUseCaseParams) -> GetAccessListParams
    @discardableResult
    func execute(params: DisplayAccessListUseCaseParams,
                 completion: @escaping AccessListUseCaseCompletion) -> Cancellable?
}

class DefaultAccessListUseCaseUseCase: DisplayAccessListUseCase {
    @Inject(from: .repositories) var repository: AccessListRepository
    @Inject private var userSession: UserSessionReadableServices
    let dayDateFormatter = ABDateFormater(with: .day)
    func execute(params: DisplayAccessListUseCaseParams,
                 completion: @escaping AccessListUseCaseCompletion) -> Cancellable? {
        let requestParams = generateRequestParams(from: params)
        repository.getAccessList(params: requestParams) { result  in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil
    }

    func generateRequestParams(from useCaseParams: DisplayAccessListUseCaseParams) -> GetAccessListParams {
        // Date Selection in UI is unclisve. Date selection in API is exclusive. We need to add 1 day to to include desired last day
        let endDate = dayDateFormatter.date(from: useCaseParams.toDate)
        let correctEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)!
        let correctEndDateString = dayDateFormatter.string(from: correctEndDate)
        let requestParams: GetAccessListParams = .init(fromDate: useCaseParams.fromDate, toDate: correctEndDateString)
        return requestParams
    }

    init() {
    }
}

struct DisplayAccessListUseCaseParams {
    let fromDate: String
    let toDate: String
}
