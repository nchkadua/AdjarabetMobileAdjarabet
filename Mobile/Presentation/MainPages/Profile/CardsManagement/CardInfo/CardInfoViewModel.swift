//
//  CardInfoViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CardInfoViewModel: CardInfoViewModelInput, CardInfoViewModelOutput {
}

public struct CardInfoViewModelParams {
    public let amount: Double

    public init (amount: Double = 0.0) {
        self.amount = amount
    }
}

public protocol CardInfoViewModelInput: AnyObject {
    var params: CardInfoViewModelParams { get set }
    func viewDidLoad()
    func setCardNumber(_ cardNumber: String?)
    func setUsageDate(month: String?, year: String?)
    func setCVV(_ cvv: String?)
    func focusOn(_ inputView: InputView)
}

public protocol CardInfoViewModelOutput {
    var action: Observable<CardInfoViewModelOutputAction> { get }
    var route: Observable<CardInfoViewModelRoute> { get }
}

public enum CardInfoViewModelOutputAction {
    case bindToCreditCardViewModel(_ viewModel: CreditCardComponentViewModel)
}

public enum CardInfoViewModelRoute {
}

public class DefaultCardInfoViewModel {
    public var params: CardInfoViewModelParams
    private let actionSubject = PublishSubject<CardInfoViewModelOutputAction>()
    private let routeSubject = PublishSubject<CardInfoViewModelRoute>()
    @Inject (from: .componentViewModels) private var creditCardViewModel: CreditCardComponentViewModel

    public init(params: CardInfoViewModelParams) {
        self.params = params
    }
}

extension DefaultCardInfoViewModel: CardInfoViewModel {
    public var action: Observable<CardInfoViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<CardInfoViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToCreditCardViewModel(creditCardViewModel))
    }

    public func setCardNumber(_ cardNumber: String?) {
        creditCardViewModel.setCardNumber(cardNumber ?? "")
    }

    public func setUsageDate(month: String?, year: String?) {
        creditCardViewModel.setUsageDate(month: month ?? "", year: year ?? "")
    }

    public func setCVV(_ cvv: String?) {
        creditCardViewModel.setCVV(cvv ?? "")
    }

    public func focusOn(_ inputView: InputView) {
        creditCardViewModel.focusOn(inputView)
    }
}
