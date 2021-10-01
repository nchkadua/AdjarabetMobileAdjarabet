//
//  MyBonusesViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MyBonusesViewModel: MyBonusesViewModelInput, MyBonusesViewModelOutput, ABCollectionViewModel {
}

public struct MyBonusesViewModelParams {
}

public protocol MyBonusesViewModelInput: AnyObject {
    var params: MyBonusesViewModelParams { get set }
    func viewDidLoad()
}

public protocol MyBonusesViewModelOutput {
    var action: Observable<MyBonusesViewModelOutputAction> { get }
    var route: Observable<MyBonusesViewModelRoute> { get }
}

public enum MyBonusesViewModelOutputAction {
	case configureEmptyState(viewModel: EmptyStateComponentViewModel)
	case initialize(AppListDataProvider)
	case reloadIndexPathes([IndexPath])
	case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
	case setLoading(LoadingType)
}

public enum MyBonusesViewModelRoute {
	case open(game: Game)
}

public class DefaultMyBonusesViewModel {
    public var params: MyBonusesViewModelParams
    private let actionSubject = PublishSubject<MyBonusesViewModelOutputAction>()
    private let routeSubject = PublishSubject<MyBonusesViewModelRoute>()

    public init(params: MyBonusesViewModelParams) {
        self.params = params
    }
}

extension DefaultMyBonusesViewModel: MyBonusesViewModel {
    public var action: Observable<MyBonusesViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MyBonusesViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
		let activeBonusSectionDataProvider = AppSectionDataProvider(
			dataProviders: [
				DefaultActiveMyBonusesHeaderComponentViewModel(params: .init()),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus")),
				DefaultActiveMyBonusItemComponentViewModel(params: .init(startDate: "აგვ 29", endDate: "აგვ 29", name: "🐸 10 FreeSpin winning season bonus"))
			]
		)
		let endedBonusSectionDataProvider = AppSectionDataProvider(
			dataProviders: [
				DefaultEndedMyBonusesHeaderComponentViewModel(params: .init()),
				DefaultEndedMyBonusItemComponentViewModel(params: .init(name: "10 FreeSpin winning season bonus", startDate: "Aug 20", endDate: "Aug 30")),
				DefaultEndedMyBonusItemComponentViewModel(params: .init(name: "10 FreeSpin winning season bonus", startDate: "Aug 20", endDate: "Aug 30")),
				DefaultEndedMyBonusItemComponentViewModel(params: .init(name: "10 FreeSpin winning season bonus", startDate: "Aug 20", endDate: "Aug 30"))
			]
		)
		let appListDataProvider = AppListDataProvider(sectionDataProviders: [
			activeBonusSectionDataProvider,
			endedBonusSectionDataProvider
		])

		actionSubject.onNext(.initialize(appListDataProvider))
    }

	public func didLoadNextPage() {
		// TODO
	}
}
