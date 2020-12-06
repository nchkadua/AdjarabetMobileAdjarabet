//
//  LoginViewModelTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 5/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
import LocalAuthentication
@testable import Mobile

extension DefaultLoginViewModel: Injectable { }

class LoginViewModelTests: XCTestCase {
    private var viewModel: DefaultLoginViewModel!

    override func setUp() {
        super.setUp()

        viewModel = DefaultLoginViewModel(params: LoginViewModelParams(showBiometryLoginAutomatically: true))
    }

    func testLoginSuccess() {
        // given
        let expectation = self.expectation(description: "Login Success")
        let useCase: LoginUseCase = LoginUseCaseSuccessMock()
        viewModel.inject(testable: useCase)
        
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
        let useCase: LoginUseCase = LoginUseCaseErrorMock()
        viewModel.inject(testable: useCase)

        _ = viewModel.route.subscribe(onNext: { action in
            if case .openAlert = action { expectation.fulfill() }
        })
        
        // when
        viewModel.login(username: "", password: "")
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testSMSCodeSuccess() {
        // given
        let expectation = self.expectation(description: "SMS Code Success")
        let useCase: SMSCodeUseCase = SMSCodeUseCaseSuccessMock()
        viewModel.inject(testable: useCase)
        
        _ = viewModel.route.subscribe(onNext: { action in
            if case .openOTP = action { expectation.fulfill() }
        })
        
        // when
        viewModel.smsLogin(username: "")
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testSMSCodeError() {
        // given
        let expectation = self.expectation(description: "SMS Code Error")
        let useCase: SMSCodeUseCase = SMSCodeUseCaseErrorMock()
        viewModel.inject(testable: useCase)

        _ = viewModel.route.subscribe(onNext: { action in
            if case .openAlert = action { expectation.fulfill() }
        })
        
        // when
        viewModel.smsLogin(username: "")
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}

private enum LoginViewModelError: Error {
    case unknown
}

// MARK: LoginUseCase Mocks
private class LoginUseCaseSuccessMock: LoginUseCase {
    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, LoginUseCaseError>) -> Void) -> Cancellable? {
        completion(.success(.success))
        return nil
    }
}

private class LoginUseCaseErrorMock: LoginUseCase {
    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, LoginUseCaseError>) -> Void) -> Cancellable? {
        completion(.failure(.unknown(error: LoginViewModelError.unknown)))
        return nil
    }
}

// MARK: OTPUseCase Mocks
private class SMSCodeUseCaseSuccessMock: SMSCodeUseCase {
    func execute(username: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        completion(.success(()))
        return nil
    }
}

private class SMSCodeUseCaseErrorMock: SMSCodeUseCase {
    func execute(username: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        completion(.failure(LoginViewModelError.unknown))
        return nil
    }
}

// MARK: Biometric Authentication
class BiometricAuthenticationSuccessMock: BiometricAuthentication {
    var hasToSucceed: Bool           = true
    var isAvailable: Bool            = true
    var biometryType: LABiometryType = .faceID
    var icon: UIImage?               = nil
    var title: String?               = nil
 
    init(hasToSucceed: Bool) {
        self.hasToSucceed = hasToSucceed
    }
    
    func authenticate(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(hasToSucceed ? .success(()) : .failure(LoginViewModelError.unknown))
    }
}
