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

    private var useCase: PaymentAccountUseCase { DefaultPaymentAccountUseCase() }

    // helper error struct
    struct EmptyError: Error { }

    func testSuccess() {

        // create Mock repository
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

        // override repository in DependencyContainer
        DependencyContainer.repositories.register { return [
            Module { MockPaymentAccountRepository() as PaymentAccountRepository }
        ] }.build()

        // test
        useCase.execute(params: .init()) { (result) in
            switch result {
            case .success(let paymentAccounts):
                XCTAssert(paymentAccounts.isEmpty)
            case .failure:
                XCTAssert(false)
            }
        }
    }

    func testCountFailure() {

        // create Mock repository
        struct MockPaymentAccountRepository: PaymentAccountRepository {
            func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                                 completion: @escaping CurrentUserPaymentAccountsCountHandler) {
                completion(.failure(EmptyError()))
            }

            func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                            completion: @escaping CurrentUserPaymentAccountsHandler) {
                completion(.success([]))
            }
        }

        // override repository in DependencyContainer
        DependencyContainer.repositories.register { return [
            Module { MockPaymentAccountRepository() as PaymentAccountRepository }
        ] }.build()

        // test
        useCase.execute(params: .init()) { (result) in
            switch result {
            case .success: XCTAssert(false)
            case .failure: XCTAssert(true)
            }
        }
    }

    func testPaymentAccountsFailure() {

        // create Mock repository
        struct MockPaymentAccountRepository: PaymentAccountRepository {
            func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                                 completion: @escaping CurrentUserPaymentAccountsCountHandler) {
                completion(.success(.init(count: 0)))
            }

            func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                            completion: @escaping CurrentUserPaymentAccountsHandler) {
                completion(.failure(EmptyError()))
            }
        }

        // override repository in DependencyContainer
        DependencyContainer.repositories.register { return [
            Module { MockPaymentAccountRepository() as PaymentAccountRepository }
        ] }.build()

        // test
        useCase.execute(params: .init()) { (result) in
            switch result {
            case .success: XCTAssert(false)
            case .failure: XCTAssert(true)
            }
        }
    }

    func testCountAndPaymentAccountsFailure() {

        // create Mock repository
        struct MockPaymentAccountRepository: PaymentAccountRepository {
            func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                                 completion: @escaping CurrentUserPaymentAccountsCountHandler) {
                completion(.failure(EmptyError()))
            }

            func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                            completion: @escaping CurrentUserPaymentAccountsHandler) {
                completion(.failure(EmptyError()))
            }
        }

        // override repository in DependencyContainer
        DependencyContainer.repositories.register { return [
            Module { MockPaymentAccountRepository() as PaymentAccountRepository }
        ] }.build()

        // test
        useCase.execute(params: .init()) { (result) in
            switch result {
            case .success: XCTAssert(false)
            case .failure: XCTAssert(true)
            }
        }
    }
}
