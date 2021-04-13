//
//  CashOutVisaViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol CashOutVisaViewModel: CashOutVisaViewModelInput,
                               CashOutVisaViewModelOutput { }

protocol CashOutVisaViewModelInput {
    /* for view to call */
    func entered(amount: String, account: Int)   // call on entering amount
    func selected(account: Int, amount: String)  // call on selecting account
    func continued(amount: String, account: Int) // call on tapping continue button
    func added()                                 // call on tapping add account button
    /* for others to mutate the state */
    func update(amount: String)
    func update(accounts: [String])
    func update(fee: String)
    func update(total: String)
    func update(isEnabled: Bool)
    func update(isLoading: Bool)
}

protocol CashOutVisaViewModelOutput {
    var action: Observable<CashOutVisaViewModelOutputAction> { get }
}

enum CashOutVisaViewModelOutputAction {
    /* for listeners */
    case entered(amount: String, account: Int)   // amount entered event
    case selected(account: Int, amount: String)  // account selected event
    case continued(amount: String, account: Int) // continue button tapped event
    case added                                   // add account button tapped event
    /* for view */
    case updateAmount(with: String)
    case updateAccounts(with: [String])
    case updateFee(with: String)
    case updateTotal(with: String)
    case updateContinueIsEnabled(with: Bool)
    case updateContinueIsLoading(with: Bool)
}

class DefaultCashOutVisaViewModel {
    private let actionSubject = PublishSubject<CashOutVisaViewModelOutputAction>()
}

extension DefaultCashOutVisaViewModel: CashOutVisaViewModel {
    var action: Observable<CashOutVisaViewModelOutputAction> { actionSubject.asObserver() }

    func entered(amount: String, account: Int) {
        notify(.entered(amount: amount, account: account))
    }

    func selected(account: Int, amount: String) {
        notify(.selected(account: account, amount: amount))
    }

    func continued(amount: String, account: Int) {
        notify(.continued(amount: amount, account: account))
    }

    func added() {
        notify(.added)
    }

    func update(amount: String) {
        notify(.updateAmount(with: amount))
    }

    func update(accounts: [String]) {
        notify(.updateAccounts(with: accounts))
    }

    func update(fee: String) {
        notify(.updateFee(with: fee))
    }

    func update(total: String) {
        notify(.updateTotal(with: total))
    }

    func update(isEnabled: Bool) {
        notify(.updateContinueIsEnabled(with: isEnabled))
    }

    func update(isLoading: Bool) {
        notify(.updateContinueIsLoading(with: isLoading))
    }

    private func notify(_ action: CashOutVisaViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
