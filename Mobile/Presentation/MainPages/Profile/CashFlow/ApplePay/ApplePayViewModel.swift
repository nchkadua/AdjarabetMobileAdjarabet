//
//  ApplePayViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ApplePayViewModel: ApplePayViewModelInput, ApplePayViewModelOutput {
}

public protocol ApplePayViewModelInput: AnyObject {
    func viewDidLoad()
    func entered(amount: String)
}

public protocol ApplePayViewModelOutput {
    var action: Observable<ApplePayViewModelOutputAction> { get }
    var route: Observable<ApplePayViewModelRoute> { get }
}

public enum ApplePayViewModelOutputAction {
    case updateMin(with: String)
    case updateDisposable(with: String)
    case updateMax(with: String)
    case updateAmount(with: String)
    case updateContinue(with: Bool)
    case show(error: String)
    case bindToGridViewModel(viewModel: SuggestedAmountGridComponentViewModel)
}

public enum ApplePayViewModelRoute {
}

public class DefaultApplePayViewModel {
    private let actionSubject = PublishSubject<ApplePayViewModelOutputAction>()
    private let routeSubject = PublishSubject<ApplePayViewModelRoute>()

    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .componentViewModels) private var suggestedAmountGridComponentViewModel: SuggestedAmountGridComponentViewModel

    private var suggested: [Double] = []
}

extension DefaultApplePayViewModel: ApplePayViewModel {
    public var action: Observable<ApplePayViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ApplePayViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        fetchSuggested()
        fetchLimits()
    }

    private func fetchSuggested() {
        suggested = [1, 1.5, 2, 2.5, 3, 3.5]

        let viewModels: [SuggestedAmountCollectionViewCellDataProvider] = suggested.compactMap { suggestedAmount in
            let vm = DefaultSuggestedAmountComponentViewModel(params: .init(amount: suggestedAmount))
            return vm
        }
        suggestedAmountGridComponentViewModel.reloadCollectionView(with: viewModels)
        notify(.bindToGridViewModel(viewModel: suggestedAmountGridComponentViewModel))
    }

    private func fetchLimits() {
        // TODO: Change with real data later
        let min = amountFormatter.format(number: 1, in: .sn)
        let disposable = amountFormatter.format(number: 10000, in: .sn)
        let max = amountFormatter.format(number: 50000, in: .sn)

        // 5. notify view to show min, disposable, max amounts
        notify(.updateMin(with: min))
        notify(.updateDisposable(with: disposable))
        notify(.updateMax(with: max))
    }

    public func entered(amount: String) {
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
        notify(.updateContinue(with: true))
    }

    private func notify(_ action: ApplePayViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
