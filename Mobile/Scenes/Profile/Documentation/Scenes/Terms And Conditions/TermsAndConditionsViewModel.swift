//
//  TermsAndConditionsViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol TermsAndConditionsViewModel: BaseViewModel, TermsAndConditionsViewModelInput, TermsAndConditionsViewModelOutput {
}

public struct TermsAndConditionsViewModelParams {
	var categories: [TermsAndConditionsEntity.Category]
	
	init(categories: [TermsAndConditionsEntity.Category] = []) {
		self.categories = categories
	}
}

public protocol TermsAndConditionsViewModelInput: AnyObject {
    var params: TermsAndConditionsViewModelParams { get set }
    func viewDidLoad()
}

public protocol TermsAndConditionsViewModelOutput {
    var action: Observable<TermsAndConditionsViewModelOutputAction> { get }
    var route: Observable<TermsAndConditionsViewModelRoute> { get }
}

public enum TermsAndConditionsViewModelOutputAction {
    case initialize(AppListDataProvider)
}

public enum TermsAndConditionsViewModelRoute {
    case openPage(destionation: String) // TODO change
}

public class DefaultTermsAndConditionsViewModel: DefaultBaseViewModel {
    public var params: TermsAndConditionsViewModelParams
    private let actionSubject = PublishSubject<TermsAndConditionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<TermsAndConditionsViewModelRoute>()

    public init(params: TermsAndConditionsViewModelParams) {
        self.params = params
    }
}

extension DefaultTermsAndConditionsViewModel: TermsAndConditionsViewModel {
    public var action: Observable<TermsAndConditionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TermsAndConditionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        var dataProviders: AppCellDataProviders = []
//        for (i, item) in TermsAndConditionsActionItemsProvider.items().enumerated() {
		for(i, item) in params.categories.enumerated() { 
            let viewModel = DefaultTermsAndConditionsComponentViewModel(params: .init(number: i+1, title: item.title))

            viewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect: self?.routeSubject.onNext(.openPage(destionation: viewModel.params.title))
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.append(viewModel)
        }

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}
