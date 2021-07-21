//
//  FAQQuestionsViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol FAQQuestionsViewModel: FAQQuestionsViewModelInput, FAQQuestionsViewModelOutput {
}

public struct FAQQuestionsViewModelParams {
}

public protocol FAQQuestionsViewModelInput: AnyObject {
    var params: FAQQuestionsViewModelParams { get set }
    func viewDidLoad()
}

public protocol FAQQuestionsViewModelOutput {
    var action: Observable<FAQQuestionsViewModelOutputAction> { get }
    var route: Observable<FAQQuestionsViewModelRoute> { get }
}

public enum FAQQuestionsViewModelOutputAction {
    case initialize(AppListDataProvider)
}

public enum FAQQuestionsViewModelRoute {
    case navigateToAnswers(questionTitle: String)
}

public class DefaultFAQQuestionsViewModel: DefaultBaseViewModel {
    public var params: FAQQuestionsViewModelParams
    private let actionSubject = PublishSubject<FAQQuestionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<FAQQuestionsViewModelRoute>()

    public init(params: FAQQuestionsViewModelParams) {
        self.params = params
    }
}

extension DefaultFAQQuestionsViewModel: FAQQuestionsViewModel {
    public var action: Observable<FAQQuestionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<FAQQuestionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        setupQuestions()
    }

    private func setupQuestions() {
        var dataProviders: AppCellDataProviders = []

        FAQCategoriesProvider.questions().forEach {
            let viewModel = DefaultFAQQuestionComponentViewModel(params: .init(question: $0.question))

            viewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect(let indexPath): self?.routeSubject.onNext(.navigateToAnswers(questionTitle: FAQCategoriesProvider.questions()[indexPath.row].question))
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.append(viewModel)
        }
        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}
