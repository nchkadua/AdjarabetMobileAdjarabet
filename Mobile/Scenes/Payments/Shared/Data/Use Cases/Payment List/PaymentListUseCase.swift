//
//  PaymentListUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentListUseCase {
    /**
     Returns list of available payment methods
     */
    typealias ListHandler = (Result<[PaymentMethodEntity], Error>) -> Void
    func list(handler: @escaping ListHandler)
}

// MARK: - Default Implementation
struct DefaultPaymentListUseCase: PaymentListUseCase {
    @Inject(from: .repositories) private var postLoginRepo: PostLoginRepository
    @Inject(from: .repositories) private var paymentListRepo: PaymentListRepository
    @Inject private var userSession: UserSessionReadableServices

    func list(handler: @escaping ListHandler) {
        guard let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        postLoginRepo.userLoggedIn(params: .init(fromRegistration: false)) { result in
            switch result {
            case .success(let userLoggedInEntity):
                paymentListRepo.list { result in
                    switch result {
                    case .success(let paymentListEntity):
                        handle(paymentListEntity, userLoggedInEntity, currency, handler)
                    case .failure(let error): handler(.failure(error))
                    }
                }
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    private func handle(_ paymentListEntity: PaymentListEntity,
                        _ userLoggedInEntity: UserLoggedInEntity,
                        _ currency: Currency,
                        _ handler: @escaping ListHandler) {
        // Define Segment Validator Function
        let validateSegment: ([String]?) -> Set<String>  = { segment in
            guard let segment = segment else {
                return [currency.description.abbreviation]
            }
            if segment.isEmpty {
                return [currency.description.abbreviation]
            }
            return Set(segment)
        }

        // Initialize Segments
        let segmentList = validateSegment(userLoggedInEntity.segmentList)
        let segmentListEmoney = validateSegment(userLoggedInEntity.segmentListEmoney)
     // let applePay = validateSegment(userLoggedInEntity.applePay)

        // Define Element Segment Validator Function
        let validateElement: ([String]?) -> Set<String> = { segment in
            if let segment = segment {
                return Set(segment)
            }
            return []
        }

        // Create result variable
        var paymentMethods: [PaymentMethodEntity] = []

        // Iterate over all payment methods
        for elem in paymentListEntity.elements {
            if elem.method.flowId.lowercased().contains("applepay") { // if Apple Pay
                paymentMethods.append(elem.method)                    // append immediately
                continue
            }

            let elemSegmentList = validateElement(elem.segmentList)
            let elemSegmentListEmoney = validateElement(elem.segmentListEmoney)
         // let elemApplePay = validateElement(elem.applePay)

            // Check for matching
            if segmentList.isSubset(of: elemSegmentList),
               segmentListEmoney.isSubset(of: elemSegmentListEmoney)
            // applePay.isSubset(of: elemApplePay)
            {
                // Append to Result
                paymentMethods.append(elem.method)
            }
        }

        handler(.success(paymentMethods))
    }
}
