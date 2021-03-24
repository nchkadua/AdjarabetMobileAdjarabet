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

public struct VisaViewModelParams {
    let serviceType: UFCServiceType
}

protocol VisaViewModelInput {
    var params: VisaViewModelParams { get set }
    func viewDidLoad()
    func entered(amount: String)
    func accountSelected(at index: Int)
    func addAccountTapped()
    func continueTapped()
}

protocol VisaViewModelOutput {
    var action: Observable<VisaViewModelOutputAction> { get }
    var route: Observable<VisaViewModelRoute> { get }
}

enum VisaViewModelOutputAction {
    case placeholdAmount(with: String)
    case updateAmount(with: String)
    case updateContinue(isUserInteractionEnabled: Bool)
    case showView(ofType: VisaViewType)
    case show(error: String)
}

enum VisaViewModelRoute {
    case webView(params: WebViewModelParams)
    case addAccount
}

/* helper models to communicate with view */

// view type enum
enum VisaViewType {
    case accounts(list: [String], selectedIndex: Int)
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
    private var accounts: [PaymentAccountEntity]?
    private var selectedAccount: Int? // index of accounts array
    private var amount: Double?

    init(params: VisaViewModelParams) {
        self.params = params
    }
}

extension DefaultVisaViewModel: VisaViewModel {
    var action: Observable<VisaViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<VisaViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        refreshState()
    }

    func entered(amount: String) {
        guard let amount = Double(amount)
        else {
            updateAmount(with: nil)
            let message = R.string.localization.deposit_visa_wrong_format_amount.localized()
            actionSubject.onNext(.show(error: message))
            return
        }
        updateAmount(with: amount)
    }

    func accountSelected(at index: Int) {
        guard let accounts = accounts,
              index == 0 || index - 1 < accounts.count // "Choose Account" Placeholder or some account was chosen
        else {
            actionSubject.onNext(.show(error: "wrong account index was passed: \(index)"))
            return
        }
        if index == 0 { // "Choose Account" Placeholder was chosen
            selectedAccount = nil
        } else { // some account was chosen, so update state
            selectedAccount = index - 1
        }
        updateContinue()
    }

    func addAccountTapped() {
        routeSubject.onNext(.addAccount)
    }

    func continueTapped() {
        guardContinuablility { result in
            guard let result = result
            else {
                let message = R.string.localization.deposit_visa_some_field_is_not_specified.localized()
                actionSubject.onNext(.show(error: message))
                return
            }
            depositUseCase.execute(serviceType: params.serviceType,
                                   amount: result.amount,
                                   accountId: result.account.id!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let request):
                    self.routeSubject.onNext(.webView(params: .init(request: request)))
                case .failure(let error):
                    self.actionSubject.onNext(.show(error: error.localizedDescription))
                }
            }
        }
    }

    /* helpers */

    private func refreshState() {
        // reinit state variables
        accounts = nil
        selectedAccount = nil
        updateAmount(with: nil) // also updates continue button
        // fetch account/card list
        accountListUseCase.execute(params: .init()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.accounts = list
                self.selectedAccount = nil // by default do not select any account = "Choose Account" Placeholder is selected
                self.refreshAccounts()     // show appropriate accounts
            case .failure(let error):
                self.actionSubject.onNext(.show(error: error.localizedDescription))
            }
        }
        // fetch suggested amount list
        let suggestedAmounts: [Double] = [1, 1.5, 2, 2.5, 3, 3.5] // TODO: Change with real data later
        /*
         TODO: Nika
         Here, create Data Providing Cell View Models using suggestedAmounts
         and Subsribe on Tap Action
         Call suggestedTapped(with:) fuction in each cells' action
         to update amount on view
         */
        // TODO: fetch min, max, once amounts lates
    }

    private func refreshAccounts() {
        if let accounts = accounts {
            if accounts.isEmpty { // if fetched account/card list is empty
                // show view with add account button
                actionSubject.onNext(.showView(ofType: .addAccount))
            } else {
                // show view with fetched card list

                /// initialize list of accounts to visualize
                var list = [R.string.localization.deposit_visa_choose_account.localized()] // first element is "Choose Account" placeholder
                list.append(contentsOf: accounts.map { $0.accountVisual! })

                /// initialize selected index
                let selectedIndex: Int
                if let selectedAccount = selectedAccount {
                    selectedIndex = selectedAccount + 1
                } else {
                    selectedIndex = 0
                }

                actionSubject.onNext(.showView(ofType: .accounts(list: list, selectedIndex: selectedIndex)))
                updateContinue()
            }
        } else {
            actionSubject.onNext(.show(error: "required state not specified"))
        }
    }

    private func suggestedTapped(with amount: Double) {
        updateAmount(with: amount)
    }

    private func updateAmount(with amount: Double?) {
        // if amount is nil, placehold amount
        guard let amount = amount
        else {
            let amountPlaceholder = R.string.localization.deposit_visa_amount.localized()
            actionSubject.onNext(.placeholdAmount(with: amountPlaceholder))
            return
        }
        // if amount is negative show error
        guard amount > 0
        else {
            let message = R.string.localization.deposit_visa_negative_amount.localized()
            actionSubject.onNext(.show(error: message))
            return
        }
        // update state
        self.amount = amount
        // visualize amount
        let formattedAmount = amountFormatter.format(amount)
        actionSubject.onNext(.updateAmount(with: formattedAmount))
        // update continue
        updateContinue()
    }

    private func updateContinue() {
        guardContinuablility { result in
            let state: Bool
            if result == nil { state = false } else { state = true }
            actionSubject.onNext(.updateContinue(isUserInteractionEnabled: state))
        }
    }

    private func guardContinuablility(_ handler: ((account: PaymentAccountEntity, amount: Double)?) -> Void) {
        if let accounts = accounts,
           let selectedAccount = selectedAccount,
           (0..<accounts.count).contains(selectedAccount),
           let amount = amount, amount > 0 {
            handler((account: accounts[selectedAccount], amount: amount))
        } else {
            handler(nil)
        }
    }
}
