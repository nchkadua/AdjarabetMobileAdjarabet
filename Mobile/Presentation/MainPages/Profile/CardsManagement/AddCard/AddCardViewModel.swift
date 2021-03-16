//
//  AddCardViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AddCardViewModel: AddCardViewModelInput, AddCardViewModelOutput {
}

public struct AddCardViewModelParams {
    public init() {
    }
}

public protocol AddCardViewModelInput: AnyObject {
    var params: AddCardViewModelParams { get set }
    func viewDidLoad()
    func continueTapped(with amount: Double, hasAgreedToTerms: Bool)
}

public protocol AddCardViewModelOutput {
    var action: Observable<AddCardViewModelOutputAction> { get }
    var route: Observable<AddCardViewModelRoute> { get }
}

public enum AddCardViewModelOutputAction {
    case bindToMinAmountComponentViewModel(_ viewModel: MinAmountComponentViewModel)
    case bindToAgreementComponentViewModel(_ viewModel: AgreementComponentViewModel)
}

public enum AddCardViewModelRoute {
    case webView(_ params: WebViewModelParams)
}

public class DefaultAddCardViewModel {
    public var params: AddCardViewModelParams
    private let actionSubject = PublishSubject<AddCardViewModelOutputAction>()
    private let routeSubject = PublishSubject<AddCardViewModelRoute>()
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    @Inject(from: .useCases) private var ufcDepositUseCase: UFCDepositUseCase

    @Inject (from: .componentViewModels) private var minAmountComponentViewModel: MinAmountComponentViewModel
    @Inject (from: .componentViewModels) private var agreementComponentViewModel: AgreementComponentViewModel

    public init(params: AddCardViewModelParams) {
        self.params = params
    }
}

extension DefaultAddCardViewModel: AddCardViewModel {
    public var action: Observable<AddCardViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AddCardViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToMinAmountComponentViewModel(minAmountComponentViewModel))
        actionSubject.onNext(.bindToAgreementComponentViewModel(agreementComponentViewModel))
    }

    public func continueTapped(with amount: Double, hasAgreedToTerms: Bool) {
        // FIXME: serviceType - .regular or .vip
        ufcDepositUseCase.execute(serviceType: .regular, amount: amount, saveAccount: hasAgreedToTerms) { [weak self] result in
            switch result {
            case .success(let request):
                self?.routeSubject.onNext(.webView(.init(request: request)))
            case .failure(let error):
                print("AddCard.Payments.DepositUseCase:", error) // FIXME
            }
        }
    }
}
