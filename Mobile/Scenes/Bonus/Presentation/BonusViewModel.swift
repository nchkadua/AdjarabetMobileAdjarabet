//
//  BonusViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol BonusViewModel: BaseViewModel,
                         BonusViewModelInput,
                         BonusViewModelOutput,
                         ABTableViewControllerDelegate,
                         AppRedrawableCellDelegate {
}

struct BonusViewModelParams {
}

protocol BonusViewModelInput: AnyObject {
    var emptyStateViewModel: EmptyStateComponentViewModel { get }
    var params: BonusViewModelParams { get set }
    func viewDidLoad()
}

protocol BonusViewModelOutput {
    var action: Observable<BonusViewModelOutputAction> { get }
    var route: Observable<BonusViewModelRoute> { get }
}

enum BonusViewModelOutputAction {
    case initialize(AppListDataProvider)
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case reloadData
    case didDeleteCell(atIndexPath: IndexPath)
    case reload(atIndexPath: IndexPath)
    case setTotalItemsCount(count: Int)
}

enum BonusViewModelRoute {
}

class DefaultBonusViewModel: DefaultBaseViewModel {
    var params: BonusViewModelParams
    public lazy var emptyStateViewModel: EmptyStateComponentViewModel =
		DefaultEmptyStateComponentViewModel(params: .init(
												icon: R.image.bonus.empty_state_icon()!,
												title: R.string.localization.bonus_empty_state_title(),
												description: R.string.localization.bonus_empty_state_description()))
    private let actionSubject = PublishSubject<BonusViewModelOutputAction>()
    private let routeSubject = PublishSubject<BonusViewModelRoute>()
    @Inject(from: .repositories) private var bonusesRepository: BonusesRepository

    init(params: BonusViewModelParams) {
        self.params = params
    }
}

extension DefaultBonusViewModel: BonusViewModel {
    var action: Observable<BonusViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<BonusViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
		bonusesRepository.getActiveBonuses(pageIndex: 1, handler: handler(onSuccessHandler: { entity in
            // In pagination login check entity.pageCount before loading next pageIndex
            print("Active bonuses: ", entity)
        }))

		bonusesRepository.getCompletedBonuses(pageIndex: 1, handler: handler(onSuccessHandler: { entity in
            // In pagination login check entity.pageCount before loading next pageIndex
            print("Completed bonuses: ", entity)
        }))
    }

    // MARK: - ABTableViewControllerDelegate

    func didDeleteCell(at indexPath: IndexPath) {
        // TODO
    }

    func didLoadNextPage() {
        // TODO
    }

    func redraw(at indexPath: IndexPath) {
        actionSubject.onNext(.reload(atIndexPath: indexPath))
    }
}
