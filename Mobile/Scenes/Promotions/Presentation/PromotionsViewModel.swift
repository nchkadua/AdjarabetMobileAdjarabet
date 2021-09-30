//
//  PromotionsViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol PromotionsViewModel: BaseViewModel, PromotionsViewModelInput, PromotionsViewModelOutput {
}

public protocol PromotionsViewModelInput {
    func viewDidLoad()
    func viewDidAppear()
    func fetchPublicPromos()
    func fetchPrivatePromos()
}

public protocol PromotionsViewModelOutput {
    var action: Observable<PromotionsViewModelOutputAction> { get }
    var route: Observable<PromotionsViewModelRoute> { get }
}

public enum PromotionsViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
    case bindToPromoTabViewModel(viewModel: PromoTabComponentViewModel)
    case isLoading(loading: Bool)
}

public enum PromotionsViewModelRoute {
}

public class DefaultPromotionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<PromotionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<PromotionsViewModelRoute>()

    @Inject(from: .useCases) private var promosUseCase: PromosUseCase
    @Inject(from: .componentViewModels) private var promoTabComponentViewModel: PromoTabComponentViewModel

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultPromotionsViewModel: PromotionsViewModel {
    public var action: Observable<PromotionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PromotionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToPromoTabViewModel(viewModel: promoTabComponentViewModel))
    }

    public func viewDidAppear() {
        observeLanguageChange()
        fetchPublicPromos()
    }

    public func fetchPublicPromos() {
        var dataProvider: AppCellDataProviders = []
        actionSubject.onNext(.initialize(dataProvider.makeList()))

        actionSubject.onNext(.isLoading(loading: true))
        promosUseCase.getPublicPromos(handler: handler(onSuccessHandler: { entity in
            entity.list.forEach {
                let model = DefaultPromotionComponentViewModel(params: .init(promoType: .publicPromo(promo: $0)))
                dataProvider.append(model)
            }
            self.actionSubject.onNext(.isLoading(loading: false))
            self.actionSubject.onNext(.initialize(dataProvider.makeList()))
        }))
    }

    public func fetchPrivatePromos() {
        var dataProvider: AppCellDataProviders = []
        actionSubject.onNext(.initialize(dataProvider.makeList()))

        actionSubject.onNext(.isLoading(loading: true))
        promosUseCase.getPrivatePromos(handler: handler(onSuccessHandler: { entity in
            entity.list.forEach {
                let model = DefaultPromotionComponentViewModel(params: .init(promoType: .privatePromo(promo: $0)))
                dataProvider.append(model)
            }
            self.actionSubject.onNext(.isLoading(loading: false))
            self.actionSubject.onNext(.initialize(dataProvider.makeList()))
        }))
    }
}
