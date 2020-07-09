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
    private var viewModel = DefaultLoginViewModel(params: .init())

    override func setUpWithError() throws {
        viewModel = DefaultLoginViewModel(params: .init())
    }

    func testLoginSuccess() {
        // given
        let expectation = self.expectation(description: "Login Success")
        let useCase: LoginUseCase = LoginUseCaseSuccessMock()
        Mirror(reflecting: viewModel).inject(testable: useCase)
        
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
        Mirror(reflecting: viewModel).inject(testable: useCase)

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
        Mirror(reflecting: viewModel).inject(testable: useCase)
        
        _ = viewModel.route.subscribe(onNext: { action in
            if case .openSMSLogin = action { expectation.fulfill() }
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
        Mirror(reflecting: viewModel).inject(testable: useCase)

        _ = viewModel.route.subscribe(onNext: { action in
            if case .openAlert = action { expectation.fulfill() }
        })
        
        // when
        viewModel.smsLogin(username: "")
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testBiometrySuccess() {
        // given
        let expectation = self.expectation(description: "Biometry Success")
        let biometry: BiometryAuthentication         = BiometryAuthenticationSuccessMock(hasToSucceed: true)
        let userSession: UserSessionReadableServices = UserSessionMock(isLoggedIn: true)
        let loginUseCase: LoginUseCase               = LoginUseCaseSuccessMock()

        Mirror(reflecting: viewModel).inject(testable: biometry)
        Mirror(reflecting: viewModel).inject(testable: userSession)
        Mirror(reflecting: viewModel).inject(testable: loginUseCase)
        
        _ = viewModel.route.subscribe(onNext: { action in
            if case .openMainTabBar = action { expectation.fulfill() }
        })
        
        // when
        viewModel.biometryLogin()
        
        // than
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testBiometryError() {
        // given
        let expectation = self.expectation(description: "Biometry Error")
        let biometry: BiometryAuthentication = BiometryAuthenticationSuccessMock(hasToSucceed: false)
        Mirror(reflecting: viewModel).inject(testable: biometry)
        
        _ = viewModel.route.subscribe(onNext: { action in
            if case .openAlert = action { expectation.fulfill() }
        })
        
        // when
        viewModel.biometryLogin()
        
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

enum LoginViewModelError: Error {
    case unknown
}

// MARK: LoginUseCase
class LoginUseCaseSuccessMock: LoginUseCase {
    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, LoginUseCaseError>) -> Void) -> Cancellable? {
        completion(.success(.success))
        return nil
    }
}

class LoginUseCaseErrorMock: LoginUseCase {
    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, LoginUseCaseError>) -> Void) -> Cancellable? {
        completion(.failure(.unknown(error: LoginViewModelError.unknown)))
        return nil
    }
}

// MARK: SMSLoginUseCase
class SMSCodeUseCaseSuccessMock: SMSCodeUseCase {
    func execute(username: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        completion(.success(()))
        return nil
    }
}

class SMSCodeUseCaseErrorMock: SMSCodeUseCase {
    func execute(username: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        completion(.failure(LoginViewModelError.unknown))
        return nil
    }
}

// MARK: UserSession
import RxSwift

class UserSessionMock: UserSessionReadableServices {
    var isLoggedIn: Bool
    
    var sessionId: String?                    = UUID().uuidString
    var userId: Int?                          = 0
    var username: String?                     = UUID().uuidString
    var password: String?                     = UUID().uuidString
    var currencyId: Int?                      = nil
    var action: Observable<UserSessionAction> = PublishSubject<UserSessionAction>()
    
    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}

// MARK: Biometry Authentication
import LocalAuthentication

class BiometryAuthenticationSuccessMock: BiometryAuthentication {
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
