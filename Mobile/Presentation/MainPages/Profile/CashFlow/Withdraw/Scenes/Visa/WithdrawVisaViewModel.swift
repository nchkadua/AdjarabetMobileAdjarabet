//
//  WithdrawVisaViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol WithdrawVisaViewModel: WithdrawVisaViewModelInput, WithdrawVisaViewModelOutput {
}

struct WithdrawVisaViewModelParams {
}

protocol WithdrawVisaViewModelInput {
    func viewDidLoad()
}

protocol WithdrawVisaViewModelOutput {
    var action: Observable<WithdrawVisaViewModelOutputAction> { get }
    var route: Observable<WithdrawVisaViewModelRoute> { get }
}

enum WithdrawVisaViewModelOutputAction {
}

enum WithdrawVisaViewModelRoute {
}

struct DefaultWithdrawVisaViewModel {
    let params: WithdrawVisaViewModelParams
    private let actionSubject = PublishSubject<WithdrawVisaViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawVisaViewModelRoute>()
}

extension DefaultWithdrawVisaViewModel: WithdrawVisaViewModel {
    var action: Observable<WithdrawVisaViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawVisaViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
    }
}
