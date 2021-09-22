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
}

public enum FAQCategoriesViewModelRoute {
    case navigateToQuestions
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

        faqRepo.getList(handler: handler(onSuccessHandler: { entity in
            print(entity)
        }))
    }

    private func setupCategories() {
        var dataProviders: AppCellDataProviders = []

        FAQCategoriesProvider.items().forEach {
            let viewModel = DefaultFAQCategoryComponentViewModel(params: .init(title: $0.title, subtitle: $0.subtitle, icon: $0.icon))

            viewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect: self?.routeSubject.onNext(.navigateToQuestions)
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.append(viewModel)
        }
        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}
