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

public protocol AddCardViewModelDelegate: AnyObject {
    func disappeared()
}

public struct AddCardViewModelParams {
    public var serviceType: UFCServiceType
    public weak var delegate: AddCardViewModelDelegate?

    public init (
        serviceType: UFCServiceType,
        delegate: AddCardViewModelDelegate? = nil
    ) {
        self.serviceType = serviceType
        self.delegate = delegate
    }
}

public protocol AddCardViewModelInput: AnyObject {
    var params: AddCardViewModelParams { get set }
    func viewDidLoad()
    func viewDidDisappear()
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

    public func viewDidDisappear() {
        params.delegate?.disappeared()
    }

    public func continueTapped(with amount: Double, hasAgreedToTerms: Bool) {
        ufcDepositUseCase.execute(serviceType: params.serviceType, amount: amount, saveAccount: hasAgreedToTerms) { [weak self] result in
            switch result {
            case .success(let request):
                self?.routeSubject.onNext(.webView(.init(request: request)))
            case .failure(let error):
                print("AddCard.Payments.DepositUseCase:", error)
            }
        }
    }
}
