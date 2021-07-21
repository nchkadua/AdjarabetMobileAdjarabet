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
    public var title: String
    public var subtitle: String
    public var icon: UIImage
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
    case set(title: String, subTitle: String, image: UIImage)
    case didSelect(indexPath: IndexPath)
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
        actionSubject.onNext(.set(title: params.title, subTitle: params.subtitle, image: params.icon))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
