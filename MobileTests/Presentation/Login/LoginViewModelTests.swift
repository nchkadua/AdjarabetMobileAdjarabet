//
//  LoginViewModelTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 5/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class LoginViewModelTests: XCTestCase {
    private var viewModel: DefaultLoginViewModel!

    override func setUpWithError() throws {
        viewModel = DefaultLoginViewModel(params: .init())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testLoginSuccess() {
        // given
        let expectation = self.expectation(description: "Login Success")
        let testLoginUseCase: LoginUseCase = LoginUseCaseSuccessMock()
        Mirror(reflecting: viewModel!).inject(testable: testLoginUseCase)
        
        _ = viewModel.route.subscribe(onNext: { action in
            if case .openMainTabBar = action { expectation.fulfill() }
        })
        
        // when
        viewModel.login(username: "", password: "")
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testLoginError() {
        // given
        let expectation = self.expectation(description: "Login Error")
        let testLoginUseCase: LoginUseCase = LoginUseCaseErrorMock()
        Mirror(reflecting: viewModel!).inject(testable: testLoginUseCase)

        _ = viewModel.route.subscribe(onNext: { action in
            if case .openAlert = action { expectation.fulfill() }
        })
        
        // when
        viewModel.login(username: "", password: "")
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}

public extension Mirror {
    func inject<T>(testable: T) {
        for child in self.children {
            if let injectable = child.value as? Inject<T> {
                injectable.storage = testable
            }
        }
    }
}

private class LoginUseCaseSuccessMock: LoginUseCase {
    func execute(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        completion(.success(()))
        return nil
    }
}

private class LoginUseCaseErrorMock: LoginUseCase {
    func execute(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        completion(.failure(LoginUseCaseError.logiFailed))
        return nil
    }
}

private enum LoginUseCaseError: Error {
    case logiFailed
}

