//
//  DepositViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol DepositViewModel: DepositViewModelInput, DepositViewModelOutput {
}

public protocol DepositViewModelInput {
    func viewDidLoad()
    func addCard()
    func proceedTapped(amount: Double, method: String, card: String)
}

public protocol DepositViewModelOutput {
    var action: Observable<DepositViewModelOutputAction> { get }
    var route: Observable<DepositViewModelRoute> { get }
}

public enum DepositViewModelOutputAction {
    case setupWithLabel(_ label: LabelComponentViewModel)
    case setupPaymentMethods(_ methods: PaymentMethods)
    case setupPaymentCards(_ cards: PaymentCards)
}

public enum DepositViewModelRoute {
    case webView(_ params: WebViewModelParams)
    case addCard
}

public class DefaultDepositViewModel {
    private let actionSubject = PublishSubject<DepositViewModelOutputAction>()
    private let routeSubject = PublishSubject<DepositViewModelRoute>()
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    // state

    private var paymentMethods: [PaymentMethodEntity] = [] {
        didSet {
            let methods = paymentMethods.map { $0.flowId }
            actionSubject.onNext(.setupPaymentMethods(.init(methods: methods)))
        }
    }

    private var paymentAccounts: [PaymentAccountEntity] = [] {
        didSet {
            let cards = paymentAccounts.map { $0.accountVisual! }
            actionSubject.onNext(.setupPaymentCards(.init(cards: cards)))
        }
    }

    @Inject public var userBalanceService: UserBalanceService
    @Inject(from: .useCases) private var paymentListUseCase: PaymentListUseCase
    @Inject(from: .useCases) private var paymentAccountUseCase: PaymentAccountUseCase
    @Inject(from: .repositories) private var repo: TBCRegularPaymentsRepository // FIXME: UseCase
}

extension DefaultDepositViewModel: DepositViewModel {
    public var action: Observable<DepositViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<DepositViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        // setup balance
        actionSubject.onNext(.setupWithLabel(LabelComponentViewModel(title: R.string.localization.balance_title(), value: "\(userBalanceService.balance?.formattedBalance ?? "0.0")"))) // FIXME: currency
        // fetch payment list
        paymentListUseCase.list { [weak self] result in
            switch result {
            case .success(let entity):
                self?.paymentMethods = entity.filter { $0.flowId.contains("deposit") }
            case .failure(let error):
                print("PaymentList.List:", error) // FIXME
            }
        }
        // fetch card list
        paymentAccountUseCase.execute(params: .init()) { [weak self] result in
            switch result {
            case .success(let entity):
                if entity.isEmpty {
                    self?.routeSubject.onNext(.addCard)
                } else {
                    self?.paymentAccounts = entity
                }
            case .failure(let error):
                print("PaymentAccounts.CardList:", error) // FIXME
            }
        }
    }

    public func proceedTapped(amount: Double, method: String, card: String) {
        // FIXME: VVV UseCase VVV
        guard let methodIndex = paymentMethods.firstIndex(where: { $0.flowId == method }),
              let cardIndex = paymentAccounts.firstIndex(where: { $0.accountVisual == card })
        else { return }

        let method = paymentMethods[methodIndex]

        if method.flowId.contains("emoney") {
            let request = httpRequestBuilder
                .set(host: "https://www.emoney.ge/index.php/main/service?id=1157")
                .set(method: HttpMethodGet())
                .build()
            self.routeSubject.onNext(.webView(.init(request: request)))
            return
        }

        // else is tbc
        let card = paymentAccounts[cardIndex]
        let accountId = card.id!

        repo.initDeposit(params: .init(amount: amount, accountId: accountId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity):
                self.deposit(amount, accountId, entity.sessionId!)
            case .failure(let error):
                print("Payment.InitDeposit:", error) // FIXME
            }
        }
    }

    private func deposit(_ amount: Double, _ accountId: Int64, _ session: String) {
        repo.deposit(params: .init(amount: amount, accountId: accountId, session: session)) { [weak self] result in
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
                    .set(host: "\(entity.url!)?trans_id=\(entity.transId!)")
                    .set(headers: headers)
                    .set(method: HttpMethodGet())
                    .build()

                self.routeSubject.onNext(.webView(.init(request: request)))

            case .failure(let error):
                print("Payment.Deposit:", error) // FIXME
            }
        }
    }
    public func addCard() {
    }
}
