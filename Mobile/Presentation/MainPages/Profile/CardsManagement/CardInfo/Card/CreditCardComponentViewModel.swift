//
//  CreditCreditCardComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CreditCardComponentViewModel: CreditCardComponentViewModelInput, CreditCardComponentViewModelOutput {
}

public protocol CreditCardComponentViewModelInput {
    func didBind()
    func setCardNumber(_ cardNumber: String)
    func setUsageDate(month: String, year: String)
    func setCVV(_ cvv: String)
    func focusOn(_ inputView: InputView)
}

public protocol CreditCardComponentViewModelOutput {
    var action: Observable<CreditCardComponentViewModelOutputAction> { get }
}

public enum CreditCardComponentViewModelOutputAction {
    case setCardNumber(_ cardNumber: String)
    case setUsageDate(month: String, year: String)
    case setCVV(_ cvv: String)
    case focusOn(_ inputView: InputView)
}

public class DefaultCreditCardComponentViewModel {
    private let actionSubject = PublishSubject<CreditCardComponentViewModelOutputAction>()
}

extension DefaultCreditCardComponentViewModel: CreditCardComponentViewModel {
    public var action: Observable<CreditCardComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
    }

    public func setCardNumber(_ cardNumber: String) {
        actionSubject.onNext(.setCardNumber(cardNumber))
    }

    public func setUsageDate(month: String, year: String) {
        actionSubject.onNext(.setUsageDate(month: month, year: year))
    }

    public func setCVV(_ cvv: String) {
        actionSubject.onNext(.setCVV(cvv))
    }

    public func focusOn(_ inputView: InputView) {
        actionSubject.onNext(.focusOn(inputView))
    }
}

public enum InputView {
    case cardNumber
    case usageDate
    case CVV
}
