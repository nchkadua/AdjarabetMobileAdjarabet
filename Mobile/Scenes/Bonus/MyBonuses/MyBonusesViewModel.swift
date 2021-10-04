//
//  MyBonusesViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import SharedFramework

public protocol MyBonusesViewModel: MyBonusesViewModelInput, MyBonusesViewModelOutput, ABCollectionViewModel {
}

public struct MyBonusesViewModelParams {
	var totalBonusAmount: Double
	var blockedAmount: Double

	public init(totalBonusAmount: Double = 0.0, blockedAmount: Double = 0.0) {
		self.totalBonusAmount = totalBonusAmount
		self.blockedAmount = blockedAmount
	}
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
	case initialize(with: AppListDataProvider)
	case reloadIndexPathes([IndexPath])
	case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
	case setLoading(LoadingType)
	case isLoading(Bool)
}

public enum MyBonusesViewModelRoute {
	case showCondition(description: String, gameId: Int?)
	case open(game: Game)
}

public class DefaultMyBonusesViewModel: DefaultBaseViewModel {
	@Inject(from: .repositories) private var bonusesRepository: BonusesRepository

	public var params: MyBonusesViewModelParams
    private let actionSubject = PublishSubject<MyBonusesViewModelOutputAction>()
    private let routeSubject = PublishSubject<MyBonusesViewModelRoute>()

	private var activeBonuses: AppCellDataProviders = [DefaultActiveMyBonusesHeaderComponentViewModel(params: .init())]
	private var activeBonusesTotalPages = 1
	private var completedBonuses: AppCellDataProviders = [DefaultEndedMyBonusesHeaderComponentViewModel(params: .init())]
	private var completedBonusesTotalPages = 1

	private var pages: (active: PageDescription, completed: PageDescription) = (active: .init(), completed: .init())
	public let loading = DefaultLoadingComponentViewModel(params: .init(tintColor: .secondaryText(), height: 55))
	private var loadingType: LoadingType = .none {
		didSet {
			guard loadingType != oldValue else { return }

			actionSubject.onNext(.setLoading(loadingType))

			let isNextPage = loadingType == .nextPage
			loading.set(isLoading: isNextPage)
		}
	}

    public init(params: MyBonusesViewModelParams) {
        self.params = params
    }

	public func load(loadingType: LoadingType) {
		loadActiveBonuses(loadingType: loadingType)
		loadCompletedBonuses(loadingType: loadingType)
	}

	private func loadActiveBonuses(loadingType: LoadingType) {
		self.loadingType = loadingType
		self.actionSubject.onNext(.isLoading(true))

		bonusesRepository.getActiveBonuses(pageIndex: pages.active.current, handler: handler(onSuccessHandler: { entity in
			defer {
				self.loadingType = .none
				self.actionSubject.onNext(.isLoading(false))
			}
			self.pages.active.itemsPerPage = entity.itemsPerPage
			self.activeBonusesTotalPages = entity.pageCount

			let bonusViewModels: [AppCellDataProvider] = entity.items.compactMap { [weak self] bonusEntity in
				guard let self = self else { return nil }
				return self.createActiveBonusComponent(from: bonusEntity)
			}

			self.appendPageToActiveBonuses(bonuses: bonusViewModels)
			if let header = self.activeBonuses[0] as? DefaultActiveMyBonusesHeaderComponentViewModel {
				header.configure(count: self.activeBonuses.count - 1)
				self.actionSubject.onNext(.reloadIndexPathes([.init(row: 0, section: 0)]))
			}
		}))
	}

	private func loadCompletedBonuses(loadingType: LoadingType) {
		self.loadingType = loadingType
		self.actionSubject.onNext(.isLoading(true))

		bonusesRepository.getCompletedBonuses(pageIndex: pages.completed.current, handler: handler(onSuccessHandler: { entity in
			defer {
				self.loadingType = .none
				self.actionSubject.onNext(.isLoading(false))
			}
			self.pages.completed.itemsPerPage = entity.itemsPerPage
			self.completedBonusesTotalPages = entity.pageCount

			let bonusViewModels: [AppCellDataProvider] = entity.items.compactMap { [weak self] bonusEntity in
				guard let self = self else { return nil }
				return self.createCompletedBonusComponent(from: bonusEntity)
			}

			self.appendPageToCompletedBonuses(bonuses: bonusViewModels)
		}))
	}

	private func createActiveBonusComponent(from entity: ActiveBonusEntity.BonusEntity) -> AppCellDataProvider {
		DefaultActiveMyBonusItemComponentViewModel(
			params: .init(
				name: entity.name,
				startDate: entity.startDate,
				endDate: entity.endDate,
				condition: entity.condition,
				gameId: entity.gameId))
	}

	private func createCompletedBonusComponent(from entity: CompletedBonusEntity.BonusEntity) -> AppCellDataProvider {
		DefaultEndedMyBonusItemComponentViewModel(
			params: .init(
				name: entity.name,
				startDate: entity.startDate,
				endDate: entity.endDate,
				condition: entity.condition,
				gameId: entity.gameId,
				delegate: self))
	}

	private func appendPageToActiveBonuses(bonuses: AppCellDataProviders) {
		let offset = activeBonuses.count

		self.pages.active.setNextPage()
		self.pages.active.configureHasMore(forNumberOfItems: activeBonuses.count)

		self.activeBonuses.append(contentsOf: bonuses)
		let indexPathes = bonuses.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
		actionSubject.onNext(.reloadItems(items: bonuses, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
	}

	private func appendPageToCompletedBonuses(bonuses: AppCellDataProviders) {
		let offset = completedBonuses.count

		self.pages.completed.setNextPage()
		self.pages.completed.configureHasMore(forNumberOfItems: completedBonuses.count)

		self.completedBonuses.append(contentsOf: bonuses)
		let indexPathes = bonuses.enumerated().map { IndexPath(item: offset + $0.offset, section: 1) }
		actionSubject.onNext(.reloadItems(items: bonuses, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
	}
}

extension DefaultMyBonusesViewModel: MyBonusesViewModel {
    public var action: Observable<MyBonusesViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MyBonusesViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
		let activeBonusesSection = AppSectionDataProvider(dataProviders: activeBonuses)
		let completedBonusesSection = AppSectionDataProvider(dataProviders: completedBonuses)

		actionSubject.onNext(.initialize(with: AppListDataProvider(sectionDataProviders: [activeBonusesSection, completedBonusesSection])))
		load(loadingType: .fullScreen)
    }

	public func didLoadNextPage() {
		// TODO: pagination for active bonuses
		guard pages.completed.current < activeBonusesTotalPages,
			  loadingType == .none else { return }
//		load(loadingType: .nextPage) // FIXME: during active bonuses implementation
		loadCompletedBonuses(loadingType: .nextPage)
	}
}

extension DefaultMyBonusesViewModel: CompletedBonusItemDelegate {
	public func hintButtonClicked(description: String, gameId: Int?) {
		routeSubject.onNext(.showCondition(description: description, gameId: gameId))
	}
}
