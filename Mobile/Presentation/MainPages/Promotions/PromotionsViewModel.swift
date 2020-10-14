//
//  PromotionsViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PromotionsViewModel: PromotionsViewModelInput, PromotionsViewModelOutput {
}

public protocol PromotionsViewModelInput {
    func viewDidLoad()
}

public protocol PromotionsViewModelOutput {
    var action: Observable<PromotionsViewModelOutputAction> { get }
    var route: Observable<PromotionsViewModelRoute> { get }
}

public enum PromotionsViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
}

public enum PromotionsViewModelRoute {
}

public class DefaultPromotionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<PromotionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<PromotionsViewModelRoute>()

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultPromotionsViewModel: PromotionsViewModel {
    public var action: Observable<PromotionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PromotionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        observeLanguageChange()

        var dataProvider: AppCellDataProviders = []

        PromotionsProvider.temporaryData().forEach {
            let model = DefaultPromotionComponentViewModel(params: PromotionComponentViewModelParams(title: $0.title, cover: $0.cover, icon: $0.icon))
            dataProvider.append(model)
        }

        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }
}
