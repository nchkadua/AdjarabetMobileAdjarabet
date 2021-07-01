//
//  NewPasswordViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NewPasswordViewModel: NewPasswordViewModelInput, NewPasswordViewModelOutput {
}

public struct NewPasswordViewModelParams {
    let confirmationCode: String
}

public protocol NewPasswordViewModelInput: AnyObject {
    var params: NewPasswordViewModelParams { get set }
    func viewDidLoad()
    func newPasswordDidChange(to newPassword: String)
    func changeDidTap(_ newPassword: String)
}

public protocol NewPasswordViewModelOutput {
    var action: Observable<NewPasswordViewModelOutputAction> { get }
    var route: Observable<NewPasswordViewModelRoute> { get }
}

public enum NewPasswordViewModelOutputAction {
    case updateRulesWithNewPassword(_ password: String)
    case setButton(loading: Bool)
    case showMessage(message: String)
}

public enum NewPasswordViewModelRoute {
}

public class DefaultNewPasswordViewModel {
    public var params: NewPasswordViewModelParams
    private let actionSubject = PublishSubject<NewPasswordViewModelOutputAction>()
    private let routeSubject = PublishSubject<NewPasswordViewModelRoute>()
    @Inject(from: .useCases) private var resetPasswordUseCase: ResetPasswordUseCase

    public init(params: NewPasswordViewModelParams) {
        self.params = params
    }
}

extension DefaultNewPasswordViewModel: NewPasswordViewModel {
    public var action: Observable<NewPasswordViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NewPasswordViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }

    public func newPasswordDidChange(to newPassword: String) {
        actionSubject.onNext(.updateRulesWithNewPassword(newPassword))
    }

    public func changeDidTap(_ newPassword: String) {
        self.actionSubject.onNext(.setButton(loading: true))
        resetPasswordUseCase.resetPassword(params: .init(confirmCode: params.confirmationCode, newPassword: newPassword)) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success: self.actionSubject.onNext(.showMessage(message: "Password Reseted Succesfully"))
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }
}
