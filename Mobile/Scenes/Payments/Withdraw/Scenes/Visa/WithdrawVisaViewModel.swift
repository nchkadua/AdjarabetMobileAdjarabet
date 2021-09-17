//
//  WithdrawVisaViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol WithdrawVisaViewModel: BaseViewModel, WithdrawVisaViewModelInput, WithdrawVisaViewModelOutput {
}

struct WithdrawVisaViewModelParams {
    let serviceType: UFCServiceType
}

protocol WithdrawVisaViewModelInput {
    func viewDidLoad()
    func added()
}

protocol WithdrawVisaViewModelOutput {
    var action: Observable<WithdrawVisaViewModelOutputAction> { get }
    var route: Observable<WithdrawVisaViewModelRoute> { get }
}

enum WithdrawVisaViewModelOutputAction {
    case showView(ofType: WithdrawViewType)
    case setAndBindCashOut(viewModel: CashOutVisaViewModel)
    case setAndBindInfo(viewModel: WithdrawVisaInfoViewModel)
    case isLoading(loading: Bool)
    case showSuccess
}
// view type enum
enum WithdrawViewType {
    case accounts
    case addAccount
}

enum WithdrawVisaViewModelRoute {
    case addAccount(params: AddCardViewModelParams)
}

class DefaultWithdrawVisaViewModel: DefaultBaseViewModel {
    let params: WithdrawVisaViewModelParams

    private let actionSubject = PublishSubject<WithdrawVisaViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawVisaViewModelRoute>()

    // use cases
    private var accountListRepository: PaymentAccountFilterableRepository = CoreApiPaymentAccountRepository()
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .useCases) private var withdrawUseCase: UFCWithdrawUseCase
    @Inject private var userBalanceService: UserBalanceService

    // components
    @Inject(from: .componentViewModels) private var cashOutViewModel: CashOutVisaViewModel
    @Inject(from: .componentViewModels) private var infoViewModel: WithdrawVisaInfoViewModel

    // state
    private var accounts: [PaymentAccountEntity] = .init()
    private var session: String?

    init(with params: WithdrawVisaViewModelParams) {
        self.params = params
    }
}

extension DefaultWithdrawVisaViewModel: WithdrawVisaViewModel {
    var action: Observable<WithdrawVisaViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawVisaViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        bind() // bind and setup view models
        refresh()
    }

    private func refresh() {
        notify(.isLoading(loading: true))
        // 0. reset state
        reset()
        // 1. fetch limits
        fetchLimits()
        // 2. fetch account/card list
        accountListRepository.list(params: .init(providerType: params.serviceType.providerType, paymentType: .withdraw)) { [weak self] result in
            guard let self = self else { return }
            defer { self.notify(.isLoading(loading: false)) }
            switch result {
            case .success(let list):
                self.accounts = list                            // 3. update accounts
                if self.accounts.isEmpty {                      // if user has no accounts:
                    self.notify(.showView(ofType: .addAccount)) // 4. notify view to show Add Account view
                } else {                                        // else:
                    self.notify(.showView(ofType: .accounts))   // 4. notify view to show Accounts view
                    // create account list for view
                    let viewAccounts = self.accounts.map { $0.accountVisual }
                    self.cashOutViewModel.update(accounts: viewAccounts) // 5. update accounts on shown view
                }
            case .failure(let error):
                self.disable()
                self.show(error: error)
            }
        }
    }

    private func reset() {
        accounts = .init()
        session = nil
        disable()
        infoViewModel.update(minimum: "-")
        infoViewModel.update(disposable: "-")
        infoViewModel.update(daily: "-")
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
            disable()
            return
        }
        // sanity check
        guard (0..<accounts.count).contains(account)
        else {
            disable()
            let message = "wrong account index was passed: \(account)"
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        // validation
        guard let amount = Double(amount.replacingOccurrences(of: ",", with: ".")),
              amount > 0
        else {
            disable()
            let message = R.string.localization.withdraw_wrong_format_amount.localized()
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
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
            disable()
            let message = "wrong account index was passed: \(account)"
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        // update continue button state
        if let amount = amountFormatter.unformat(number: amount, from: .s_n_a) { // is not placeholder and correct amount
            initSession(account: account, amount: amount)
        } else {
            disable()
        }
    }

    func continued(amount: String, account: Int) {
        // sanity check
        guard (0..<accounts.count).contains(account),                              // sanity check
              let damount = amountFormatter.unformat(number: amount, from: .s_n_a) // amount is valid
        else {
            disable()
            let message = "wrong parameters was passed - amount: \(amount); account: \(account)"
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        // guard necessary parameters for transaction
        guard let session = session,
              let serviceType = UFCServiceType(account: accounts[account])
        else {
            disable()
            let message = R.string.localization.withdraw_missing_params_error.localized()
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        cashOutViewModel.update(isLoading: true)
        withdrawUseCase.execute(serviceType: serviceType,
                                amount: damount,
                                accountId: accounts[account].id,
                                session: session) { [weak self] result in
            guard let self = self else { return }
            self.cashOutViewModel.update(isLoading: false)
            switch result {
            case .success:
                self.userBalanceService.update()
                // reset state for next transaction
                self.notify(.showSuccess)
                self.cashOutViewModel.update(amount: "")
                self.disable()
            case .failure(let error):
                self.disable()
                self.show(error: error)
            }
        }
    }

    func added() {
        routeSubject.onNext(.addAccount(params: .init(serviceType: params.serviceType, delegate: self)))
    }

    private func initSession(account: Int, amount: Double) {
        // assumption: sanity check on accounts already done
        guard let serviceType = UFCServiceType(account: accounts[account])
        else {
            disable()
            let message = R.string.localization.withdraw_service_type_init_error.localized()
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
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
                self.cashOutViewModel.update(isEnabled: true)
            case .failure(let error):
                self.disable()
                self.show(error: error)
            }
        }
    }

    /* helpers */

    private func notify(_ action: WithdrawVisaViewModelOutputAction) {
        actionSubject.onNext(action)
    }

    private func disable() {
        cashOutViewModel.update(isEnabled: false)
    }
}

extension DefaultWithdrawVisaViewModel: AddCardViewModelDelegate {
    func disappeared() {
        refresh()
    }
}

fileprivate extension UFCServiceType {
    var providerType: PaymentAccountFilterableListParams.ProviderType {
        switch self {
        case .regular: return .visaRegular
        case .vip:     return .visaVip
        }
    }
}
