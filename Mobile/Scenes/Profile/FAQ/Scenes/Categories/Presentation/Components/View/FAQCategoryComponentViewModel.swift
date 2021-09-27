//
//  FAQCategoryComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol FAQCategoryComponentViewModel: FAQCategoryComponentViewModelInput,
                                                FAQCategoryComponentViewModelOutput {}

public struct FAQCategoryComponentViewModelParams {
    public var category: FAQCategory
}

public protocol FAQCategoryComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol FAQCategoryComponentViewModelOutput {
    var action: Observable<FAQCategoryComponentViewModelOutputAction> { get }
    var params: FAQCategoryComponentViewModelParams { get }
}

public enum FAQCategoryComponentViewModelOutputAction {
    case set(title: String, description: String, iconUrl: String)
    case didSelect(category: FAQCategory, indexPath: IndexPath)
}

public class DefaultFAQCategoryComponentViewModel {
    public var params: FAQCategoryComponentViewModelParams
    private let actionSubject = PublishSubject<FAQCategoryComponentViewModelOutputAction>()
    public init(params: FAQCategoryComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultFAQCategoryComponentViewModel: FAQCategoryComponentViewModel {
    public var action: Observable<FAQCategoryComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.category.title, description: params.category.description, iconUrl: params.category.icon))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(category: params.category, indexPath: indexPath))
    }
}
