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
    func  login(code: String)
}

public protocol SMSLoginViewModelOutput {
    var action: Observable<SMSLoginViewModelOutputAction> { get }
    var route: Observable<SMSLoginViewModelRoute> { get }
    var params: SMSLoginViewModelParams { get }
}

public enum SMSLoginViewModelOutputAction {
    case configureSMSInputForNumberOfItems(Int)
    case updateSMSCodeInputView(text: [String?])
    case loginButton(isLoading: Bool)
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

    public init(params: SMSLoginViewModelParams) {
        self.params = params
    }
}

extension DefaultSMSLoginViewModel: SMSLoginViewModel {
    public var action: Observable<SMSLoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SMSLoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.configureSMSInputForNumberOfItems(smsCodeLength))
    }

    public func textDidChange(to text: String?) {
        let text = text ?? ""

        let texts = (0..<smsCodeLength).map { index in
            index < text.count ? String(text[text.index(text.startIndex, offsetBy: index)]) : nil
        }

        actionSubject.onNext(.updateSMSCodeInputView(text: texts))
    }

    public func shouldChangeCharacters(for text: String) -> Bool {
        text.count <= smsCodeLength
    }

    public func shoudEnableLoginButton(fot text: String?) -> Bool {
        (text ?? "").count == smsCodeLength
    }

    public func login(code: String) {
        actionSubject.onNext(.loginButton(isLoading: true))
        smsLoginUseCase.execute(username: params.username, code: code) { [weak self] result in
            defer { self?.actionSubject.onNext(.loginButton(isLoading: false)) }
            switch result {
            case .success: self?.routeSubject.onNext(.openMainTabBar)
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }
}
