//
//  WithdrawViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol WithdrawViewModel: WithdrawViewModelInput, WithdrawViewModelOutput { }

protocol WithdrawViewModelInput {
    func viewDidLoad()                           // call on viewDidLoad()
    func entered(amount: String, account: Int)   // call on entering amount
    func selected(account: Int, amount: String)  // call on selecting account
    func continued(amount: String, account: Int) // call on tapping continue button
    func added()                                 // call on tapping add account button
}

protocol WithdrawViewModelOutput {
    var action: Observable<WithdrawViewModelOutputAction> { get }
    var route: Observable<WithdrawViewModelRoute> { get }
}

enum WithdrawViewModelOutputAction {
    case showView(ofType: WithdrawViewType)
    case updateAmount(with: String)
    case updateAccounts(with: [String])
    case updateFee(with: String)
    case updateSum(with: String)
    case updateContinue(with: Bool)
    case updateMin(with: String)
    case updateDisposable(with: String)
    case updateMax(with: String)
    case show(error: String)
}
// view type enum
enum WithdrawViewType {
    case accounts
    case addAccount
}

enum WithdrawViewModelRoute {
    case addAccount
}

class DefaultWithdrawViewModel {
    private let actionSubject = PublishSubject<WithdrawViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawViewModelRoute>()
    // use cases
    @Inject(from: .useCases) private var withdrawUseCase: UFCWithdrawUseCase
    // state
}

extension DefaultWithdrawViewModel: WithdrawViewModel {
    var action: Observable<WithdrawViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        //
    }

    func entered(amount: String, account: Int) {
        //
    }

    func selected(account: Int, amount: String) {
        //
    }

    func continued(amount: String, account: Int) {
        //
    }

    func added() {
        routeSubject.onNext(.addAccount)
    }
}
