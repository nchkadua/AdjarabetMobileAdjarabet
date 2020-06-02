//
//  HomeViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput, ABCollectionViewModel {
}

public protocol HomeViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func didLoadNextPage()
}

public protocol HomeViewModelOutput {
    var action: Observable<HomeViewModelOutputAction> { get }
    var route: Observable<HomeViewModelRoute> { get }
}

public enum HomeViewModelOutputAction {
    case languageDidChange
    case reloadIndexPathes([IndexPath])
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case initialize(AppListDataProvider)
}

public enum HomeViewModelRoute {
}

public class DefaultHomeViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<HomeViewModelOutputAction>()
    private let routeSubject = PublishSubject<HomeViewModelRoute>()

    @Inject private var userBalanceService: UserBalanceService

    private var page: PageDescription = .init()
    private var games: AppCellDataProviders = []
    private var loadingType: LoadingType = .none {
        didSet {
            guard loadingType != oldValue else {return}

            let isNextPage = loadingType == .nextPage
            loading.set(isLoading: isNextPage)
            let indexPath = IndexPath(item: games.count, section: 0)
            actionSubject.onNext(.reloadIndexPathes([indexPath]))
        }
    }

    public let loading = DefaultLoadingComponentViewModel(params: .init(tintColor: .neutral100(), height: 55))

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }

    private func load(loadingType: LoadingType) {
        self.loadingType = loadingType
        let offset = self.games.count

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int.random(in: 100...2000))) {
            defer { self.loadingType = .none }

            let items: AppCellDataProviders = (1...20).map {
                let params = GameLauncherComponentViewModelParams(
                    id: UUID().uuidString,
                    coverUrl: DummyData.imageUrls.randomElement()!,
                    name: "Game name \(offset +  $0)",
                    category: "category \(offset + $0)",
                    jackpotAmount: Bool.random() ? nil : "$ 50,2319.98")
                let viewModel = DefaultGameLauncherComponentViewModel(params: params)
                viewModel.action.subscribe(onNext: { action in
                    print(action)
                }).disposed(by: self.disposeBag)
                return viewModel
            }

            self.appendPage(games: items)
        }
    }

    private func appendPage(games: AppCellDataProviders) {
        let offset = self.games.count

        self.page.current += 1
        self.page.hasMore = self.games.count < 50
        self.games.append(contentsOf: games)

        let indexPathes = games.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
        actionSubject.onNext(.reloadItems(items: games, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    }
}

extension DefaultHomeViewModel: HomeViewModel {
    public var action: Observable<HomeViewModelOutputAction> { actionSubject.asObserver() }

    public var route: Observable<HomeViewModelRoute> { routeSubject.asObserver() }

    public func viewWillAppear() {
        userBalanceService.update()
    }

    public func viewDidLoad() {
        observeLanguageChange()
        let section = AppSectionDataProvider(dataProviders: [loading])
        actionSubject.onNext(.initialize(AppListDataProvider(sectionDataProviders: [section])))
        load(loadingType: .fullScreen)
    }

    public func didLoadNextPage() {
        guard page.hasMore, loadingType == .none else {return}
        load(loadingType: .nextPage)
    }
}
