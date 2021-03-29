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
    case showMessage(message: String)
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
    @Inject(from: .useCases) private var accountListUseCase: PaymentAccountUseCase
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .useCases) private var withdrawUseCase: UFCWithdrawUseCase
    // state
    private var accounts: [PaymentAccountEntity] = .init()
    private var session: String?
}

extension DefaultWithdrawViewModel: WithdrawViewModel {
    var action: Observable<WithdrawViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        // 0. update continue to non-interactive
        notify(.updateContinue(with: false))
        // 1. fetch account/card list
        accountListUseCase.execute(params: .init()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.accounts = list                            // 2. update accounts
                if self.accounts.isEmpty {                      // if user has no accounts:
                    self.notify(.showView(ofType: .addAccount)) // 3. notify view to show Add Account view
                } else {                                        // else:
                    self.notify(.showView(ofType: .accounts))   // 3. notify view to show Accounts view
                    // create account list for view
                    let viewAccounts = self.accounts.map { $0.accountVisual! }
                    self.notify(.updateAccounts(with: viewAccounts)) // 4. update accounts on shown view
                    self.fetchLimits() // continue here...
                }
            case .failure(let error):
                self.reset()
                self.actionSubject.onNext(.show(error: error.localizedDescription))
            }
        }
    }

    private func fetchLimits() {
        // 4. fetch min, disposable, max amounts
        // TODO: Change with real data later
        let min = amountFormatter.format(number: 1, in: .sn)
        let disposable = amountFormatter.format(number: 10000, in: .sn)
        let max = amountFormatter.format(number: 50000, in: .sn)
        // 5. notify view to show min, disposable, max amounts
        notify(.updateMin(with: min))
        notify(.updateDisposable(with: disposable))
        notify(.updateMax(with: max))
        // 6. clean amount field
        notify(.updateAmount(with: ""))
    }

    func entered(amount: String, account: Int) {
        // reset session
        session = nil
        // if empty amount do nothing, just clean everything
        if amount.isEmpty {
            reset()
            return
        }
        // sanity check
        guard (0..<accounts.count).contains(account)
        else {
            reset()
            notify(.show(error: "wrong account index was passed: \(account)"))
            return
        }
        // validation
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        guard let amount = formatter.number(from: amount)?.doubleValue, amount > 0
        else {
            reset()
            let message = R.string.localization.deposit_visa_wrong_format_amount.localized()
            notify(.show(error: message))
            return
        }
        /*
         * TODO:
         * Check for min, disposable
         */
        // notify to update amount with formatted version
        let formattedAmount = amountFormatter.format(number: amount, in: .s_n_a)
        notify(.updateAmount(with: formattedAmount))
        initSession(account: account, amount: amount)
    }

    func selected(account: Int, amount: String) {
        // reset session
        session = nil
        // sanity check
        guard (0..<accounts.count).contains(account)
        else {
            reset()
            notify(.show(error: "wrong account index was passed: \(account)"))
            return
        }
        // update continue button state
        if let amount = amountFormatter.unformat(number: amount, from: .s_n_a) { // is not placeholder and correct amount
            initSession(account: account, amount: amount)
        } else {
            reset()
        }
    }

    private func initSession(account: Int, amount: Double) {
        // assumption: sanity check on accounts already done
        guard let serviceType = UFCServiceType(account: accounts[account])
        else {
            reset()
            let error =  R.string.localization.withdraw_service_type_init_error.localized()
            notify(.show(error: error))
            return
        }
        withdrawUseCase.execute(serviceType: serviceType, amount: amount) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity):
                // 1. save session
                self.session = entity.session
                // 2. update fee
                let fee = self.amountFormatter.format(number: entity.fee, in: .sn)
                self.notify(.updateFee(with: fee))
                // 3. update sum
                let sum = self.amountFormatter.format(number: amount + entity.fee, in: .s_n_a)
                self.notify(.updateSum(with: sum))
                // 4. update continue button
                self.notify(.updateContinue(with: true))
            case .failure(let error):
                self.reset()
                self.notify(.show(error: error.localizedDescription))
            }
        }
    }

    func continued(amount: String, account: Int) {
        // sanity check
        guard (0..<accounts.count).contains(account),                              // sanity check
              let damount = amountFormatter.unformat(number: amount, from: .s_n_a) // amount is valid
        else {
            reset()
            notify(.show(error: "wrong parameters was passed - amount: \(amount); account: \(account)"))
            return
        }
        // guard necessary parameters for transaction
        guard let session = session,
              let serviceType = UFCServiceType(account: accounts[account])
        else {
            reset()
            let error = R.string.localization.withdraw_missing_params_error.localized()
            notify(.show(error: error))
            return
        }
        withdrawUseCase.execute(serviceType: serviceType,
                                amount: damount,
                                accountId: accounts[account].id!,
                                session: session) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let success = R.string.localization.withdraw_transaction_successed.localized()
                self.notify(.showMessage(message: success))
            case .failure(let error):
                self.reset()
                self.notify(.show(error: error.localizedDescription))
            }
        }
    }

    private func reset() {
        notify(.updateFee(with: ""))
        notify(.updateSum(with: ""))
        notify(.updateContinue(with: false))
    }

    func added() {
        routeSubject.onNext(.addAccount)
    }

    /* helpers */

    private func notify(_ action: WithdrawViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
