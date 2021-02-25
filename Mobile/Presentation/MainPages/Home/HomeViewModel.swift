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
    func viewDidAppear()
    func didLoadNextPage()
    func layoutChangeTapped()
}

public protocol HomeViewModelOutput {
    var action: Observable<HomeViewModelOutputAction> { get }
    var route: Observable<HomeViewModelRoute> { get }
}

public enum HomeViewModelOutputAction {
    case setLoading(LoadingType)
    case languageDidChange
    case reloadIndexPathes([IndexPath])
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case initialize(AppListDataProvider)
}

public enum HomeViewModelRoute {
    case openGame(title: String)
}

public class DefaultHomeViewModel: DefaultBaseViewModel {
    private enum GamesLayout {
        case list
        case grid
    }
    private var selectedLayout: GamesLayout = .list
    private let actionSubject = PublishSubject<HomeViewModelOutputAction>()
    private let routeSubject = PublishSubject<HomeViewModelRoute>()

    @Inject(from: .useCases) private var lobbyGamesUseCase: LobbyGamesUseCase
    @Inject(from: .useCases) private var recentlyPlayedGamesUseCase: RecentlyPlayedGamesUseCase
    @Inject private var userBalanceService: UserBalanceService

    private var page: PageDescription = .init()
    private var games: AppCellDataProviders = []
    public let loading = DefaultLoadingComponentViewModel(params: .init(tintColor: .secondaryText(), height: 55))
    private var fetchedGames: [Game] = []
    private var loadingType: LoadingType = .none {
        didSet {
            guard loadingType != oldValue else {return}

            actionSubject.onNext(.setLoading(loadingType))

            let isNextPage = loadingType == .nextPage
            loading.set(isLoading: isNextPage)
            let indexPath = IndexPath(item: games.count, section: 1)
            actionSubject.onNext(.reloadIndexPathes([indexPath]))
        }
    }

    private lazy var recentlyPlayedComponentViewModel: DefaultRecentlyPlayedComponentViewModel = {
        let params = RecentlyPlayedComponentViewModelParams(
            id: UUID().uuidString,
            title: R.string.localization.recently_played,
            buttonTitle: R.string.localization.view_all,
            playedGames: [],
            isVisible: true)

        let recentryPlayed = DefaultRecentlyPlayedComponentViewModel(params: params)

        recentryPlayed.action.subscribe(onNext: { action in
            switch action {
            case .didSelectViewAll:
                self.routeSubject.onNext(.openGame(title: "View All"))
            case .didSelectPlayedGame(let model, _):
                self.routeSubject.onNext(.openGame(title: model.params.game.name))
            default: break
            }
        }).disposed(by: disposeBag)

        return recentryPlayed
    }()

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }

    public func load(loadingType: LoadingType) {
        self.loadingType = loadingType
        lobbyGamesUseCase.execute(request: .init(page: page.current, itemsPerPage: page.itemsPerPage)) { result in
            defer { self.loadingType = .none }

            switch result {
            case .success(let params):
                self.saveGamesToCache(params.games)
                let viewModels: [AppCellDataProvider] = params.games.compactMap { [weak self] in
                    guard let self = self else {return nil}
                    return self.createGameComponentFrom(game: $0)
                }
                self.appendPage(games: viewModels)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupListGameLauncherComponentFrom(game: Game) -> DefaultGameLauncherComponentViewModel {
        let vm = DefaultGameLauncherComponentViewModel(game: game)
        vm.action.subscribe(onNext: { action in
            switch action {
            case .didSelect(let model, _): self.routeSubject.onNext(.openGame(title: model.params.game.name))
            default: break
            }
        }).disposed(by: self.disposeBag)
        return vm
    }
    
    private func setupGridGameLauncherComponentFrom(game: Game) -> DefaultGameLauncherGridComponentViewModel {
        let vm = DefaultGameLauncherGridComponentViewModel(game: game)
//        vm.action.subscribe(onNext: { action in
//            switch action {
//            case .didSelect(let model, _): self.routeSubject.onNext(.openGame(title: model.params.game.name))
//            default: break
//            }
//        }).disposed(by: self.disposeBag)
        return vm
    }
    
    private func createGameComponentFrom(game: Game) -> AppCellDataProvider {
        return selectedLayout == GamesLayout.list ? setupListGameLauncherComponentFrom(game: game) : setupGridGameLauncherComponentFrom(game: game)
    }
    
    private func saveGamesToCache(_ games: [Game]) {
        fetchedGames.append(contentsOf: games)
    }
    
    private func appendPage(games: AppCellDataProviders) {
        let offset = self.games.count

        self.page.setNextPage()
        self.page.configureHasMore(forNumberOfItems: games.count)

        self.games.append(contentsOf: games)

        let indexPathes = games.enumerated().map { IndexPath(item: offset + $0.offset, section: 1) }
        actionSubject.onNext(.reloadItems(items: games, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    }

    private func loadRecentryPlayedGames() {
        recentlyPlayedGamesUseCase.execute(request: .init(page: 1, itemsPerPage: 20)) { result in
            switch result {
            case .success(let params):
                let viewModels: [PlayedGameLauncherCollectionViewCellDataProvider] = params.games.compactMap { [weak self] in
                    guard let self = self else {return nil}

                    let vm = DefaultPlayedGameLauncherComponentViewModel(params: .init(game: $0, lastWon: nil))
                    vm.action.subscribe(onNext: { action in
                        switch action {
                        case .didSelect(let model, _): self.routeSubject.onNext(.openGame(title: model.params.game.name))
                        default: break
                        }
                    }).disposed(by: self.disposeBag)
                    return vm
                }

                self.recentlyPlayedComponentViewModel.params.playedGames = viewModels
                self.recentlyPlayedComponentViewModel.params.isVisible = !viewModels.isEmpty
                self.actionSubject.onNext(.reloadIndexPathes([IndexPath(item: 0, section: 0)]))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DefaultHomeViewModel: HomeViewModel {
    
    public func layoutChangeTapped() {
        DisplayEmptyGames()
        selectedLayout = selectedLayout == GamesLayout.list ? .grid : .list
        let viewModels: [AppCellDataProvider] = fetchedGames.compactMap {
            let vm = createGameComponentFrom(game: $0)
            return vm
        }
        games = []
        page = .init()
        self.appendPage(games: viewModels)
    }
    
    public var action: Observable<HomeViewModelOutputAction> { actionSubject.asObserver() }

    public var route: Observable<HomeViewModelRoute> { routeSubject.asObserver() }

    public func viewWillAppear() {
        userBalanceService.update()
    }

    public func viewDidLoad() {
        observeLanguageChange()

        DisplayEmptyGames()

        loadRecentryPlayedGames()
        load(loadingType: .fullScreen)
    }
    
    private func DisplayEmptyGames() {
        let recentryPlayedSection = AppSectionDataProvider(dataProviders: [recentlyPlayedComponentViewModel])
        let gamesSection = AppSectionDataProvider(dataProviders: [loading])

        actionSubject.onNext(.initialize(AppListDataProvider(sectionDataProviders: [recentryPlayedSection, gamesSection])))
    }

    public func viewDidAppear() {
        // TODO
//        ABLocationManager.sharedInstance.load()
    }

    public func didLoadNextPage() {
        guard page.hasMore, loadingType == .none else {return}
        load(loadingType: .nextPage)
    }
}
