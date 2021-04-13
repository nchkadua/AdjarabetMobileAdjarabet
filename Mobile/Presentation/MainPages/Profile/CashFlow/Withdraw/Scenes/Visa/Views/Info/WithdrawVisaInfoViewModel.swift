//
//  WithdrawVisaInfoViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol WithdrawVisaInfoViewModel: WithdrawVisaInfoViewModelInput,
                                    WithdrawVisaInfoViewModelOutput { }

protocol WithdrawVisaInfoViewModelInput {
    /* for others to mutate the state */
    func update(minimum: String)
    func update(disposable: String)
    func update(daily: String)
}

protocol WithdrawVisaInfoViewModelOutput {
    var action: Observable<WithdrawVisaInfoViewModelOutputAction> { get }
}

enum WithdrawVisaInfoViewModelOutputAction {
    /* for view */
    case updateMinimum(with: String)
    case updateDisposable(with: String)
    case updateDaily(with: String)
}

class DefaultWithdrawVisaInfoViewModel {
    private let actionSubject = PublishSubject<WithdrawVisaInfoViewModelOutputAction>()
}

extension DefaultWithdrawVisaInfoViewModel: WithdrawVisaInfoViewModel {
    var action: Observable<WithdrawVisaInfoViewModelOutputAction> { actionSubject.asObserver() }

    func update(minimum: String) {
        notify(.updateMinimum(with: minimum))
    }

    func update(disposable: String) {
        notify(.updateDisposable(with: disposable))
    }

    func update(daily: String) {
        notify(.updateDaily(with: daily))
    }

    private func notify(_ action: WithdrawVisaInfoViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
