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

public struct PromotionsViewModelParams {
}

public protocol PromotionsViewModelInput {
    func viewDidLoad()
}

public protocol PromotionsViewModelOutput {
    var action: Observable<PromotionsViewModelOutputAction> { get }
    var route: Observable<PromotionsViewModelRoute> { get }
    var params: PromotionsViewModelParams { get }
}

public enum PromotionsViewModelOutputAction {
    case languageDidChange
}

public enum PromotionsViewModelRoute {
}

public class DefaultPromotionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<PromotionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<PromotionsViewModelRoute>()
    public let params: PromotionsViewModelParams

    public init(params: PromotionsViewModelParams) {
        self.params = params
    }

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultPromotionsViewModel: PromotionsViewModel {
    public var action: Observable<PromotionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PromotionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        observeLanguageChange()
    }
}
