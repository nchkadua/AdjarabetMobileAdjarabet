//
//  WithdrawViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol WithdrawViewModel: WithdrawViewModelInput, WithdrawViewModelOutput {
}

public protocol WithdrawViewModelInput {
    func viewDidLoad()
    func handleTextDidChange(amount: Double)
    func proceedTapped(amount: Double)
}

public protocol WithdrawViewModelOutput {
    var action: Observable<WithdrawViewModelOutputAction> { get }
    var route: Observable<WithdrawViewModelRoute> { get }
}

public enum WithdrawViewModelOutputAction {
    case setupWithLabel(_ label: LabelComponentViewModel)
    case setupPaymentMethods(_ payment: Payment)
    case updateTotalAmount(_ value: String)
    case updateSumWith(_ fee: Double)
    case showAlert(_ message: String)
}

public enum WithdrawViewModelRoute {
}

public class DefaultWithdrawViewModel {
    private let actionSubject = PublishSubject<WithdrawViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawViewModelRoute>()

    @Inject public var userBalanceService: UserBalanceService
    @Inject(from: .useCases) private var ufcWithdrawUseCase: UFCWithdrawUseCase

    private var session: String?
}

extension DefaultWithdrawViewModel: WithdrawViewModel {
    public var action: Observable<WithdrawViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<WithdrawViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupWithLabel(LabelComponentViewModel(title: R.string.localization.balance_title(), value: "\(userBalanceService.balance?.formattedBalance ?? "0.0") ₾"))) // FIXME: Currency
        actionSubject.onNext(.setupPaymentMethods(Payment()))
    }

    public func handleTextDidChange(amount: Double) {
        // FIXME: serviceType
        ufcWithdrawUseCase.execute(serviceType: .regular, amount: amount) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.actionSubject.onNext(.updateSumWith(entity.fee))
                self?.session = entity.session
            case .failure(let error): self?.actionSubject.onNext(.showAlert(error.localizedDescription))
            }
        }
    }

    public func proceedTapped(amount: Double) {
        guard let session = session else {
            actionSubject.onNext(.showAlert("Session Uninitialized"))
            return
        }
        ufcWithdrawUseCase.execute(serviceType: .regular, amount: amount, accountId: 9313241, session: session) { [weak self] result in
            switch result {
            case .success: self?.actionSubject.onNext(.showAlert("Transaction Successfull"))
            case .failure(let error): self?.actionSubject.onNext(.showAlert(error.localizedDescription))
            }
        }
    }
}
