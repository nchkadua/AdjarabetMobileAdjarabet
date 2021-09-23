//
//  FAQCategoriesViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol FAQCategoriesViewModel: BaseViewModel, FAQCategoriesViewModelInput, FAQCategoriesViewModelOutput {
}

public struct FAQCategoriesViewModelParams {
    let showDismissButton: Bool
}

public protocol FAQCategoriesViewModelInput: AnyObject {
    var params: FAQCategoriesViewModelParams { get set }
    func viewDidLoad()
}

public protocol FAQCategoriesViewModelOutput {
    var action: Observable<FAQCategoriesViewModelOutputAction> { get }
    var route: Observable<FAQCategoriesViewModelRoute> { get }
}

public enum FAQCategoriesViewModelOutputAction {
    case initialize(AppListDataProvider)
    case isLoading(loading: Bool)
}

public enum FAQCategoriesViewModelRoute {
    case navigateToQuestions(questions: [FAQQuestion])
}

public class DefaultFAQCategoriesViewModel: DefaultBaseViewModel {
    public var params: FAQCategoriesViewModelParams
    private let actionSubject = PublishSubject<FAQCategoriesViewModelOutputAction>()
    private let routeSubject = PublishSubject<FAQCategoriesViewModelRoute>()
    @Inject(from: .repositories) private var faqRepo: FAQRepository

    public init(params: FAQCategoriesViewModelParams) {
        self.params = params
    }
}

extension DefaultFAQCategoriesViewModel: FAQCategoriesViewModel {
    public var action: Observable<FAQCategoriesViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<FAQCategoriesViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        setupCategories()
    }

    private func setupCategories() {
        actionSubject.onNext(.isLoading(loading: true))
        var dataProviders: AppCellDataProviders = []
        faqRepo.getList(handler: handler(onSuccessHandler: { entity in
            entity.categories.forEach {
                let viewModel = DefaultFAQCategoryComponentViewModel(params: .init(category: $0))
                viewModel.action.subscribe(onNext: { action in
                    switch action {
                    case .didSelect(let category, _): self.routeSubject.onNext(.navigateToQuestions(questions: category.questions))
                    default: break
                    }
                }).disposed(by: self.disposeBag)
                dataProviders.append(viewModel)
            }
            self.actionSubject.onNext(.initialize(dataProviders.makeList()))
            self.actionSubject.onNext(.isLoading(loading: false))
        }))
    }
}
