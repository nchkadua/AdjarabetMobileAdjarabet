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
}

public enum PromotionsViewModelRoute {
}

public class DefaultPromotionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<PromotionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<PromotionsViewModelRoute>()

    @Inject(from: .componentViewModels) private var promoTabComponentViewModel: PromoTabComponentViewModel

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultPromotionsViewModel: PromotionsViewModel {
    public var action: Observable<PromotionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PromotionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        observeLanguageChange()
        actionSubject.onNext(.bindToPromoTabViewModel(viewModel: promoTabComponentViewModel))
        fetchPublicPromos()
    }

    public func fetchPublicPromos() {
        var dataProvider: AppCellDataProviders = []

        PromotionsProvider.temporaryPublicData().forEach {
            let model = DefaultPromotionComponentViewModel(params: PromotionComponentViewModelParams(title: $0.title, cover: $0.cover, icon: $0.icon))
            dataProvider.append(model)
        }

        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }

    public func fetchPrivatePromos() {
        var dataProvider: AppCellDataProviders = []

        PromotionsProvider.temporaryPrivateData().forEach {
            let model = DefaultPromotionComponentViewModel(params: PromotionComponentViewModelParams(title: $0.title, cover: $0.cover, icon: $0.icon))
            dataProvider.append(model)
        }

        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }
}
