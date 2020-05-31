//
//  HomeViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

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
    case appendGames(AppCellDataProviders, [IndexPath])
    case initialize(AppListDataProvider)
}

public enum HomeViewModelRoute {
}

public enum HomeViewModelLoading {
    case none
    case fullScreen
    case nextPage
}

public class DefaultHomeViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<HomeViewModelOutputAction>()
    private let routeSubject = PublishSubject<HomeViewModelRoute>()

    @Inject private var userBalanceService: UserBalanceService

    private var page: PageDescription = .init()
    private var games: AppCellDataProviders = []
    private var loadingType: HomeViewModelLoading = .none

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }

    private func load(loadingType: HomeViewModelLoading) {
        self.loadingType = loadingType

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            defer { self.loadingType = .none }

            let items: AppCellDataProviders = (1...20).map {
                let params = GameLauncherComponentViewModelParams(
                    id: UUID().uuidString,
                    coverUrl: DummyData.imageUrls.randomElement()!,
                    name: "Game name \($0)",
                    category: "category \($0)",
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
        self.games.append(contentsOf: games)

        let indexPathes = games.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
        actionSubject.onNext(.appendGames(games, indexPathes))
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
        actionSubject.onNext(.initialize(AppListDataProvider(sectionDataProvider: AppSectionDataProvider())))
        load(loadingType: .fullScreen)
    }

    public func didLoadNextPage() {
        guard page.hasMore, loadingType == .none else {return}
        load(loadingType: .nextPage)
    }
}
