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
    let serviceType: UFCServiceType
}

protocol WithdrawVisaViewModelInput {
    func viewDidLoad()
}

protocol WithdrawVisaViewModelOutput {
    var action: Observable<WithdrawVisaViewModelOutputAction> { get }
    var route: Observable<WithdrawVisaViewModelRoute> { get }
}

enum WithdrawVisaViewModelOutputAction {
    case showView(ofType: WithdrawViewType)
    case setAndBindCashOut(viewModel: CashOutVisaViewModel)
    case setAndBindInfo(viewModel: WithdrawVisaInfoViewModel)
    case show(error: String)
    case showMessage(message: String)
}
// view type enum
enum WithdrawViewType {
    case accounts
    case addAccount
}

enum WithdrawVisaViewModelRoute {
    case addAccount
}

class DefaultWithdrawVisaViewModel {
    let params: WithdrawVisaViewModelParams

    private let actionSubject = PublishSubject<WithdrawVisaViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawVisaViewModelRoute>()

    // use cases
    @Inject(from: .useCases) private var accountListUseCase: PaymentAccountUseCase
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .useCases) private var withdrawUseCase: UFCWithdrawUseCase

    // components
    @Inject(from: .componentViewModels) private var cashOutViewModel: CashOutVisaViewModel
    @Inject(from: .componentViewModels) private var infoViewModel: WithdrawVisaInfoViewModel

    // state
    private var accounts: [PaymentAccountEntity] = .init()
    private var session: String?

    private var disposeBag = DisposeBag()

    init(with params: WithdrawVisaViewModelParams) {
        self.params = params
    }
}

extension DefaultWithdrawVisaViewModel: WithdrawVisaViewModel {
    var action: Observable<WithdrawVisaViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawVisaViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        // bind and setup view models
        bind()
        // 0. fetch limits
        fetchLimits()
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
                    self.cashOutViewModel.update(accounts: viewAccounts) // 4. update accounts on shown view
                 // self.fetchLimits() // continue here...
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
        let minimum = amountFormatter.format(number: 1, in: .sn)
        let disposable = amountFormatter.format(number: 10000, in: .sn)
        let daily = amountFormatter.format(number: 50000, in: .sn)
        // 5. notify view to show min, disposable, max amounts
        infoViewModel.update(minimum: minimum)
        infoViewModel.update(disposable: disposable)
        infoViewModel.update(daily: daily)
        // 6. clean amount field
        cashOutViewModel.update(amount: "")
    }

    private func bind() {
        bindCashOutViewModel()
        bindInfoViewModel()
    }

    private func bindCashOutViewModel() {
        // set and bind to view
        notify(.setAndBindCashOut(viewModel: cashOutViewModel))
        // listen to events
        cashOutViewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func bindInfoViewModel() {
        // set and bind to view
        notify(.setAndBindInfo(viewModel: infoViewModel))
    }

    private func didRecive(action: CashOutVisaViewModelOutputAction) {
        switch action {
        case .entered(let amount, let account):
            entered(amount: amount, account: account)
        case .selected(let account, let amount):
            selected(account: account, amount: amount)
        case .continued(let amount, let account):
            continued(amount: amount, account: account)
        case .added:
            added()
        default: break
        }
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
        guard let amount = Double(amount.replacingOccurrences(of: ",", with: ".")),
              amount > 0
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
        cashOutViewModel.update(amount: formattedAmount)
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
            let error = "" // R.string.localization.withdraw_missing_params_error.localized()
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
                let success = "" // R.string.localization.withdraw_transaction_successed.localized()
                self.notify(.showMessage(message: success))
            case .failure(let error):
                self.reset()
                self.notify(.show(error: error.localizedDescription))
            }
        }
    }

    func added() {
        routeSubject.onNext(.addAccount)
    }

    private func initSession(account: Int, amount: Double) {
        // assumption: sanity check on accounts already done
        guard let serviceType = UFCServiceType(account: accounts[account])
        else {
            reset()
            let error = "" // R.string.localization.withdraw_service_type_init_error.localized()
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
                self.cashOutViewModel.update(fee: fee)
                // 3. update total
                let total = self.amountFormatter.format(number: amount + entity.fee, in: .s_n_a)
                self.cashOutViewModel.update(total: total)
                // 4. update continue button
                self.cashOutViewModel.update(continue: true)
            case .failure(let error):
                self.reset()
                self.notify(.show(error: error.localizedDescription))
            }
        }
    }

    /* helpers */

    private func notify(_ action: WithdrawVisaViewModelOutputAction) {
        actionSubject.onNext(action)
    }

    private func reset() {
        cashOutViewModel.update(fee: "")
        cashOutViewModel.update(total: "")
        cashOutViewModel.update(continue: false)
    }
}
