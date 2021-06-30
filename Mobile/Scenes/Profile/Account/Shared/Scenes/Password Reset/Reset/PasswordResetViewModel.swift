//
//  PasswordResetViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PasswordResetViewModel: PasswordResetViewModelInput, PasswordResetViewModelOutput {
}

public struct PasswordResetViewModelParams {
}

public protocol PasswordResetViewModelInput: AnyObject {
    var params: PasswordResetViewModelParams { get set }
    func viewDidLoad()
}

public protocol PasswordResetViewModelOutput {
    var action: Observable<PasswordResetViewModelOutputAction> { get }
    var route: Observable<PasswordResetViewModelRoute> { get }
}

public enum PasswordResetViewModelOutputAction {
    case setupPhoneNumber(_ number: String)
    case showMessage(message: String)
}

public enum PasswordResetViewModelRoute {
}

public class DefaultPasswordResetViewModel {
    public var params: PasswordResetViewModelParams
    private let actionSubject = PublishSubject<PasswordResetViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordResetViewModelRoute>()
    @Inject(from: .useCases) private var resetPasswordUseCase: ResetPasswordUseCase

    public init(params: PasswordResetViewModelParams) {
        self.params = params
    }
}

extension DefaultPasswordResetViewModel: PasswordResetViewModel {
    public var action: Observable<PasswordResetViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordResetViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        resetPasswordUseCase.initPasswordReset { result in
            switch result {
            case .success(let entity):
                self.actionSubject.onNext(.setupPhoneNumber(entity.tel ?? "No phone number"))
            case .failure(let error):
                self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
        /*
            resetPasswordUseCase.getPasswordResetCode(params: .init(address: "995577131188", channelType: .sms)) { result in
                switch result {
                case .success(let entity): print(entity)
                case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
                }
            } Commented till UI is done */
    }
}
