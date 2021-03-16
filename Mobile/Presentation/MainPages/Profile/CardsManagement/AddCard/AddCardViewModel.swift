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
    func continueTapped(with amount: Double)
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

    @Inject(from: .repositories) private var repo: TBCRegularPaymentsRepository // FIXME: UseCase

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

    public func continueTapped(with amount: Double) {
        repo.initDeposit(params: .init(amount: amount)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity):
                self.deposit(amount, entity.session)
            case .failure(let error):
                print("Payment.InitDeposit:", error) // FIXME
            }
        }
    }

    private func deposit(_ amount: Double, _ session: String) {
        repo.deposit(params: .init(amount: amount, session: session)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity):

                let headers = [ // FIXME: Common
                    "Cache-control": "no-store",
                    "Connection": "Keep-Alive",
                    "Keep-Alive": "timeout=5, max=100",
                    "Pragma": "no-cache",
                    "X-Content-Type-Options": "nosniff",
                    "X-XSS-Protection": "1; mode=block"
                ]

                let request = self.httpRequestBuilder
                    .set(host: "\(entity.url)?trans_id=\(entity.transactionId)")
                    .set(headers: headers)
                    .set(method: HttpMethodGet())
                    .build()

                self.routeSubject.onNext(.webView(.init(request: request)))

            case .failure(let error):
                print("Payment.Deposit:", error) // FIXME
            }
        }
    }
}
