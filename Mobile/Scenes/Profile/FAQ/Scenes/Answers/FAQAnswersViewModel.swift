//
//  FAQAnswersViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 21.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol FAQAnswersViewModel: BaseViewModel, FAQAnswersViewModelInput, FAQAnswersViewModelOutput {
}

public struct FAQAnswersViewModelParams {
    let showDismissButton: Bool
    let questionTitle: String
}

public protocol FAQAnswersViewModelInput: AnyObject {
    var params: FAQAnswersViewModelParams { get set }
    func viewDidLoad()
}

public protocol FAQAnswersViewModelOutput {
    var action: Observable<FAQAnswersViewModelOutputAction> { get }
    var route: Observable<FAQAnswersViewModelRoute> { get }
}

public enum FAQAnswersViewModelOutputAction {
    case setTitle(title: String)
}

public enum FAQAnswersViewModelRoute {
}

public class DefaultFAQAnswersViewModel: DefaultBaseViewModel {
    public var params: FAQAnswersViewModelParams
    private let actionSubject = PublishSubject<FAQAnswersViewModelOutputAction>()
    private let routeSubject = PublishSubject<FAQAnswersViewModelRoute>()

    public init(params: FAQAnswersViewModelParams) {
        self.params = params
    }
}

extension DefaultFAQAnswersViewModel: FAQAnswersViewModel {
    public var action: Observable<FAQAnswersViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<FAQAnswersViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setTitle(title: params.questionTitle))
    }
}
