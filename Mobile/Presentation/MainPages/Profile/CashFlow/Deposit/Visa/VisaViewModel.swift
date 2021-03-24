//
//  VisaViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol VisaViewModel: VisaViewModelInput, VisaViewModelOutput {
}

struct VisaViewModelParams {
    let serviceType: UFCServiceType
}

protocol VisaViewModelInput {
    var params: VisaViewModelParams { get set }
    func viewDidLoad()                           // call on viewDidLoad()
    func entered(amount: String, account: Int)   // call on entering amount
    func selected(account: Int, amount: String)  // call on selecting account
    func continued(amount: String, account: Int) // call on tapping continue button
    func added()                                 // call on tapping add account button
}

protocol VisaViewModelOutput {
    var action: Observable<VisaViewModelOutputAction> { get }
    var route: Observable<VisaViewModelRoute> { get }
}

enum VisaViewModelOutputAction {
    case showView(ofType: VisaViewType)
    case enterAmount(with: String) // view should call viewModel.entered(amount:, accountIndex:)
    case updateAmount(with: String)
    case updateAccounts(with: [String])
    case updateContinue(with: Bool)
    case updateMin(with: String)
    case updateDisposable(with: String)
    case updateMax(with: String)
    case show(error: String)
}
// view type enum
enum VisaViewType {
    case accounts
    case addAccount
}

enum VisaViewModelRoute {
    case webView(with: WebViewModelParams)
    case addAccount
}

class DefaultVisaViewModel {
    var params: VisaViewModelParams
    private let actionSubject = PublishSubject<VisaViewModelOutputAction>()
    private let routeSubject = PublishSubject<VisaViewModelRoute>()
    // use cases
    @Inject(from: .useCases) private var accountListUseCase: PaymentAccountUseCase
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .useCases) private var depositUseCase: UFCDepositUseCase
    // state
    private var accounts: [PaymentAccountEntity] = .init()

    init(params: VisaViewModelParams) {
        self.params = params
    }
}

extension DefaultVisaViewModel: VisaViewModel {
    var action: Observable<VisaViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<VisaViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        refresh()
    }

    private func refresh() {
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
                    var viewAccounts = [R.string.localization.deposit_visa_choose_account.localized()] // first element is "Choose Account" placeholder
                    viewAccounts.append(contentsOf: self.accounts.map { $0.accountVisual! })
                    self.notify(.updateAccounts(with: viewAccounts)) // 4. update accounts on shown view
                    self.fetchSuggested() // continue here...
                }
            case .failure(let error):
                self.actionSubject.onNext(.show(error: error.localizedDescription))
            }
        }
    }

    private func fetchSuggested() {
        // 3. fetch suggested amount list
        // TODO: Change with real data later
        let suggested: [Double] = [1, 1.5, 2, 2.5, 3, 3.5]
        /*
         TODO: Nika
         Here, create Data Providing Cell View Models using "suggested"
         and Subsribe on Tap Action
         Call suggestedTapped(with:) function in each cells' action
         to update amount on view
         */
        fetchLimits() // continue here...
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
        // sanity check
        guard (0...accounts.count).contains(account) // == because of placeholder
        else {
            notify(.show(error: "wrong account index was passed: \(account)"))
            return
        }
        // validation
        guard let amount = Double(amount), amount > 0
        else {
            notify(.updateContinue(with: false))
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

        if account > 0 { // is not placeholder
            notify(.updateContinue(with: true))
        }
    }

    func selected(account: Int, amount: String) {
        // sanity check
        guard (0...accounts.count).contains(account) // == because of placeholder
        else {
            notify(.show(error: "wrong account index was passed: \(account)"))
            return
        }
        // update continue button state
        if account == 0 || amountFormatter.unformat(number: amount, from: .s_n_a) == nil { // is placeholder or wrong amount
            notify(.updateContinue(with: false))
        } else {
            notify(.updateContinue(with: true))
        }
    }

    func continued(amount: String, account: Int) {
        // sanity check
        guard (0..<accounts.count).contains(account - 1),                          // non-placeholder is checked
              let damount = amountFormatter.unformat(number: amount, from: .s_n_a) // amount is valid
        else {
            notify(.show(error: "wrong parameters was passed - amount: \(amount); account: \(account)"))
            return
        }
        depositUseCase.execute(serviceType: params.serviceType,
                               amount: damount,
                               accountId: accounts[account - 1].id!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let request):
                self.routeSubject.onNext(.webView(with: .init(request: request)))
            case .failure(let error):
                self.actionSubject.onNext(.show(error: error.localizedDescription))
            }
        }
    }

    func added() {
        routeSubject.onNext(.addAccount)
    }

    /* helpers */

    private func suggestedTapped(with amount: Double) {
        notify(.enterAmount(with: "\(amount)"))
    }

    private func notify(_ action: VisaViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
