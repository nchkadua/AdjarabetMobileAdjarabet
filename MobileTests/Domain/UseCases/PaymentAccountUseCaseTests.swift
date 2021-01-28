//
//  PaymentAccountUseCaseTests.swift
//  MobileTests
//
//  Created by Giorgi Kratsashvili on 1/28/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class PaymentAccountUseCaseTests: XCTestCase {

    struct MockPaymentAccountRepository: PaymentAccountRepository {
        func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                             completion: @escaping CurrentUserPaymentAccountsCountHandler) {
            completion(.success(.init(count: 0)))
        }

        func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                        completion: @escaping CurrentUserPaymentAccountsHandler) {
            completion(.success([]))
        }
    }

    func testExample() throws {

        DependencyContainer.repositories.register { () -> [Module] in
            return [ Module { MockPaymentAccountRepository() as PaymentAccountRepository } ]
        }.build()

        let useCase: PaymentAccountUseCase = DefaultPaymentAccountUseCase()

        useCase.execute(params: .init()) { (result) in
            switch result {
            case .success(let paymentAccounts): // type - [PaymentAccountEntity]
                print("Test Success:", paymentAccounts)
            case .failure(let error):
                print("Test Failure:", error)
            }
        }

        print("Assert")
        XCTAssert(true)
    }
}
