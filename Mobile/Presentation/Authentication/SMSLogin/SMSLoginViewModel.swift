//
//  SMSLoginViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SMSLoginViewModel: SMSLoginViewModelInput, SMSLoginViewModelOutput {
}

public struct SMSLoginViewModelParams {
    public let username: String
}

public protocol SMSLoginViewModelInput {
    func viewDidLoad()
    func textDidChange(to text: String?)
    func shouldChangeCharacters(for text: String) -> Bool
    func shoudEnableLoginButton(fot text: String?) -> Bool
    func resendSMS()
    func login(code: String)
}

public protocol SMSLoginViewModelOutput {
    var action: Observable<SMSLoginViewModelOutputAction> { get }
    var route: Observable<SMSLoginViewModelRoute> { get }
    var params: SMSLoginViewModelParams { get }
}

public enum SMSLoginViewModelOutputAction {
    case setSMSInputViewNumberOfItems(Int)
    case setSMSCodeInputView(text: [String?])
    case setResendSMSButton(isLoading: Bool)
    case setLoginButton(isLoading: Bool)
}

public enum SMSLoginViewModelRoute {
    case openMainTabBar
    case openAlert(title: String, message: String? = nil)
}

public class DefaultSMSLoginViewModel {
    private let actionSubject = PublishSubject<SMSLoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<SMSLoginViewModelRoute>()
    public let params: SMSLoginViewModelParams
    private let smsCodeLength = 6

    @Inject(from: .useCases) private var smsLoginUseCase: SMSLoginUseCase
    @Inject(from: .useCases) private var smsCodeUseCase: SMSCodeUseCase

    public init(params: SMSLoginViewModelParams) {
        self.params = params
    }
}

extension DefaultSMSLoginViewModel: SMSLoginViewModel {
    public var action: Observable<SMSLoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SMSLoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setSMSInputViewNumberOfItems(smsCodeLength))
    }

    public func textDidChange(to text: String?) {
        let text = text ?? ""

        let texts = (0..<smsCodeLength).map { index in
            index < text.count ? String(text[text.index(text.startIndex, offsetBy: index)]) : nil
        }

        actionSubject.onNext(.setSMSCodeInputView(text: texts))
    }

    public func shouldChangeCharacters(for text: String) -> Bool {
        text.count <= smsCodeLength
    }

    public func shoudEnableLoginButton(fot text: String?) -> Bool {
        (text ?? "").count == smsCodeLength
    }

    public func resendSMS() {
        actionSubject.onNext(.setResendSMSButton(isLoading: true))
        smsCodeUseCase.execute(username: params.username) { [weak self] result in
            defer { self?.actionSubject.onNext(.setResendSMSButton(isLoading: false)) }
            switch result {
            case .success: print(result)
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }

    public func login(code: String) {
        actionSubject.onNext(.setLoginButton(isLoading: true))
        smsLoginUseCase.execute(username: params.username, code: code) { [weak self] result in
            defer { self?.actionSubject.onNext(.setLoginButton(isLoading: false)) }
            switch result {
            case .success: self?.routeSubject.onNext(.openMainTabBar)
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }
}
