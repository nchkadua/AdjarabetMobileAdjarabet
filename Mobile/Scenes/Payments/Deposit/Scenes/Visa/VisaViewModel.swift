//
//  VisaViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol VisaViewModel: BaseViewModel, VisaViewModelInput, VisaViewModelOutput { }

public struct VisaViewModelParams {
    let serviceType: UFCServiceType
}

protocol VisaViewModelInput {
    var params: VisaViewModelParams { get set }
    func viewDidLoad()                           // call on viewDidLoad()
    func entered(amount: String)                 // call on entering amount
    func selected(account: Int, amount: String)  // call on selecting account
    func continued(amount: String, account: Int) // call on tapping continue button
    func added()
}

protocol VisaViewModelOutput {
    var action: Observable<VisaViewModelOutputAction> { get }
    var route: Observable<VisaViewModelRoute> { get }
}

enum VisaViewModelOutputAction {
    case showView(ofType: VisaViewType)
    case updateAmount(with: String)
    case updateAccounts(with: [String])
    case updateContinue(with: Bool)
    case updateMin(with: String)
    case updateDisposable(with: String)
    case updateMax(with: String)
    case bindToGridViewModel(viewModel: SuggestedAmountGridComponentViewModel)
}
// view type enum
enum VisaViewType {
    case accounts
    case addAccount
}

enum VisaViewModelRoute {
    case webView(with: WebViewModelParams)
    case addAccount(params: AddCardViewModelParams)
}

class DefaultVisaViewModel: DefaultBaseViewModel {
    var params: VisaViewModelParams
    private let actionSubject = PublishSubject<VisaViewModelOutputAction>()
    private let routeSubject = PublishSubject<VisaViewModelRoute>()
    // use cases
    private var accountListRepository: PaymentAccountFilterableRepository = WebApiPaymentAccountRepository()
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .useCases) private var depositUseCase: UFCDepositUseCase
    // state
    private var accounts: [PaymentAccountEntity] = .init()
    var suggested: [Double] = []

    @Inject(from: .componentViewModels) private var suggestedAmountGridComponentViewModel: SuggestedAmountGridComponentViewModel

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
        // 0. update continue to non-interactive
        notify(.updateContinue(with: false))
        // 1. fetch account/card list
        accountListRepository.list(params: .init(providerType: params.serviceType.providerType, paymentType: .deposit), handler: handler(onSuccessHandler: { list in
            self.accounts = list                            // 2. update accounts
            if self.accounts.isEmpty {                      // if user has no accounts:
                self.notify(.showView(ofType: .addAccount)) // 3. notify view to show Add Account view
            } else {                                        // else:
                self.notify(.showView(ofType: .accounts))   // 3. notify view to show Accounts view
                // create account list for view
                let viewAccounts = self.accounts.map { $0.accountVisual }
                self.notify(.updateAccounts(with: viewAccounts)) // 4. update accounts on shown view
                self.fetchSuggested() // continue here...
            }
        }))
    }

    private func fetchSuggested() {
        suggested = [1, 1.5, 2, 2.5, 3, 3.5]

        let viewModels: [SuggestedAmountCollectionViewCellDataProvider] = suggested.compactMap { suggestedAmount in
            let vm = DefaultSuggestedAmountComponentViewModel(params: .init(amount: suggestedAmount))
            return vm
        }
        suggestedAmountGridComponentViewModel.reloadCollectionView(with: viewModels)
        notify(.bindToGridViewModel(viewModel: suggestedAmountGridComponentViewModel))

        fetchLimits()
    }

    private func fetchLimits() {
        // 4. fetch min, disposable, max amounts
        // TODO: Change with real data later
        var min = amountFormatter.format(number: 1, in: .sn)
        var disposable = amountFormatter.format(number: 10000, in: .sn)
        var max = amountFormatter.format(number: 50000, in: .sn)

        if params.serviceType == .vip {
            min = amountFormatter.format(number: 1, in: .sn)
            disposable = amountFormatter.format(number: 50000, in: .sn)
            max = amountFormatter.format(number: 100000, in: .sn)
        }

        // 5. notify view to show min, disposable, max amounts
        notify(.updateMin(with: min))
        notify(.updateDisposable(with: disposable))
        notify(.updateMax(with: max))
        // 6. clean amount field
        notify(.updateAmount(with: ""))
    }

    func entered(amount: String) {
        // if empty amount do nothing
        if amount.isEmpty {
            notify(.updateContinue(with: false))
            return
        }
        // validation
        guard let amount = Double(amount.replacingOccurrences(of: ",", with: ".")),
              amount > 0
        else {
            notify(.updateContinue(with: false))
            let message = R.string.localization.deposit_visa_wrong_format_amount.localized()
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        /*
         * TODO:
         * Check for min, disposable
         */
        // notify to update amount with formatted version
        let formattedAmount = amountFormatter.format(number: amount, in: .s_n_a)
        notify(.updateAmount(with: formattedAmount))
        notify(.updateContinue(with: true))
    }

    func selected(account: Int, amount: String) {
        // sanity check
        guard (0..<accounts.count).contains(account)
        else {
            let message = "wrong account index was passed: \(account)"
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        // update continue button state
        if amountFormatter.unformat(number: amount, from: .s_n_a) == nil { // is placeholder or wrong amount
            notify(.updateContinue(with: false))
        } else {
            notify(.updateContinue(with: true))
        }
    }

    func continued(amount: String, account: Int) {
        // sanity check
        guard (0..<accounts.count).contains(account),                              // sanity check
              let damount = amountFormatter.unformat(number: amount, from: .s_n_a) // amount is valid
        else {
            let message = "wrong parameters was passed - amount: \(amount); account: \(account)"
            show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        depositUseCase.execute(serviceType: params.serviceType,
                               amount: damount,
                               accountId: accounts[account].id,
                               handler: handler(onSuccessHandler: { request in
                                self.routeSubject.onNext(.webView(with: .init(loadType: .urlRequst(request: request), canNavigate: false)))
                               }))
    }

    func added() {
        routeSubject.onNext(.addAccount(params: .init(serviceType: params.serviceType)))
    }

    /* helpers */

    private func suggestedTapped(with amount: Double) {
        entered(amount: "\(amount)")
    }

    private func notify(_ action: VisaViewModelOutputAction) {
        actionSubject.onNext(action)
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
