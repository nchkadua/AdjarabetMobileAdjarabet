//
//  HomeViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HomeViewModel: BaseViewModel, HomeViewModelInput, HomeViewModelOutput, ABCollectionViewModel {
}

class HomeViewModelParams {
    var error: ABError?
    init(error: ABError? = nil) {
        self.error = error
    }
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func didLoadNextPage()
}

protocol HomeViewModelOutput: AnyObject {
    var params: HomeViewModelParams { get set }
    var action: Observable<HomeViewModelOutputAction> { get }
    var route: Observable<HomeViewModelRoute> { get }
}

enum HomeViewModelOutputAction {
    case setLoading(LoadingType)
    case reloadIndexPathes([IndexPath])
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case initialize(AppListDataProvider)
    case replaceSection(index: Int, dataProvider: AppSectionDataProvider)
}

enum HomeViewModelRoute {
    case open(game: Game)
    case accessHistory
}

class DefaultHomeViewModel: DefaultBaseViewModel {
    var params: HomeViewModelParams = .init()
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

	@Inject(from: .repositories) private var userInfoRepo: UserInfoReadableRepository // FIXME: remove after testing

    private var page: PageDescription = .init()
    private var recentlyPlayedGames: AppCellDataProviders = []
    private var games: AppCellDataProviders = []
    public let loading = DefaultLoadingComponentViewModel(params: .init(tintColor: .secondaryText(), height: 55))
    private let placeholderSection = AppSectionDataProvider(dataProviders: [
        DefaultEmptyCollectionViewCellDataProvider()
    ])
    private let bannerSection = AppSectionDataProvider(dataProviders: [
        DefaultABSliderViewModel(slides: [
            .init(image: R.image.home.banner1()!),
            .init(image: R.image.home.banner2()!),
            .init(image: R.image.home.banner1()!),
            .init(image: R.image.home.banner2()!),
            .init(image: R.image.home.banner1()!)
        ]),
        DefaultLayoutChooserViewModel()
    ])
    // swiftlint:disable force_cast
    private var layoutChooserViewModel: LayoutChooserViewModel { bannerSection[1] as! LayoutChooserViewModel }
    // swiftlint:enable force_cast
    private var fetchedGames: [Game] = []
    private var loadingType: LoadingType = .none {
        didSet {
            guard loadingType != oldValue else {return}

            actionSubject.onNext(.setLoading(loadingType))

            let isNextPage = loadingType == .nextPage
            loading.set(isLoading: isNextPage)
            let indexPath = IndexPath(item: max(games.count - topCapacity, 0), section: 4)
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
                {}() // self.routeSubject.onNext(.openGame(title: "View All"))
            case .didSelectPlayedGame(let model, _):
                self.routeSubject.onNext(.open(game: model.params.game))
            default: break
            }
        }).disposed(by: disposeBag)

        return recentryPlayed
    }()

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
                self.show(error: error)
            }
        }
    }

    private func setupListGameLauncherComponentFrom(game: Game) -> DefaultGameLauncherComponentViewModel {
        let vm = DefaultGameLauncherComponentViewModel(game: game)
        vm.action.subscribe(onNext: { action in
            switch action {
            case .didSelect(let model, _): self.routeSubject.onNext(.open(game: model.params.game))
            default: break
            }
        }).disposed(by: self.disposeBag)
        return vm
    }

    private func setupGridGameLauncherComponentFrom(game: Game) -> DefaultGameLauncherGridComponentViewModel {
        let vm = DefaultGameLauncherGridComponentViewModel(game: game)
        vm.action.subscribe(onNext: { action in
            switch action {
            case .didSelect(let model, _): self.routeSubject.onNext(.open(game: model.params.game))
            default: break
            }
        }).disposed(by: self.disposeBag)
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

        let spaceInTop = topCapacity - offset

        let bottom: ArraySlice<AppCellDataProvider>

        if spaceInTop > 0 {
            bottom = games.dropFirst(spaceInTop)
            let top = games.prefix(spaceInTop)

            let indexPathes = top.enumerated().map { IndexPath(item: offset + $0.offset, section: 2) }
            actionSubject.onNext(.reloadItems(items: Array(top), insertionIndexPathes: indexPathes, deletionIndexPathes: []))
        } else {
            bottom = games.dropFirst(0)
        }

        if !bottom.isEmpty {
            let ofs = max(offset - topCapacity, 0)
            let indexPathes = bottom.enumerated().map { IndexPath(item: ofs + $0.offset, section: 4) }
            actionSubject.onNext(.reloadItems(items: Array(bottom), insertionIndexPathes: indexPathes, deletionIndexPathes: []))
        }
    }

    private func loadRecentryPlayedGames() {
        recentlyPlayedGamesUseCase.execute(request: .init(page: 1, itemsPerPage: 20)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let params):
                let viewModels: [PlayedGameLauncherCollectionViewCellDataProvider] = params.games.compactMap { [weak self] in
                    guard let self = self else {return nil}

                    let vm = DefaultPlayedGameLauncherComponentViewModel(params: .init(game: $0, lastWon: nil))
                    vm.action.subscribe(onNext: { action in
                        switch action {
                        case .didSelect(let model, _): self.routeSubject.onNext(.open(game: model.params.game))
                        default: break
                        }
                    }).disposed(by: self.disposeBag)
                    self.recentlyPlayedGames.append(vm)
                    return vm
                }

                self.recentlyPlayedComponentViewModel.params.playedGames = viewModels
                self.recentlyPlayedComponentViewModel.params.isVisible = !viewModels.isEmpty
                self.actionSubject.onNext(.reloadIndexPathes([IndexPath(item: 0, section: 3)]))
            case .failure(let error):
                self.show(error: error)
            }
        }
    }

    private func observeLayoutChange() {
        layoutChooserViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .listLayoutTapped: self?.layoutChangeTapped(at: .list)
            case .gridLayoutTapped: self?.layoutChangeTapped(at: .grid)
            }
        }).disposed(by: disposeBag)
    }

    private func layoutChangeTapped(at layout: GamesLayout) {
        games = []
        page = .init()
     // displayEmptyGames()
        selectedLayout = layout
        let viewModels: [AppCellDataProvider] = fetchedGames.compactMap {
            let vm = createGameComponentFrom(game: $0)
            return vm
        }
        actionSubject.onNext(.replaceSection(index: 2, dataProvider: .init(dataProviders: [])))
        actionSubject.onNext(.replaceSection(index: 4, dataProvider: .init(dataProviders: [loading])))
        self.appendPage(games: viewModels)
    }

    override func errorActionHandler(buttonType: ABError.Description.Popup.ButtonType, error: ABError) {
        if case .lastAccessFromDifferentIP = error.type,
           case .lastAccesses = buttonType {
            routeSubject.onNext(.accessHistory)
        }
    }

    private var topCapacity: Int { selectedLayout == .list ? 4 : 6 }
}

extension DefaultHomeViewModel: HomeViewModel {
    public var action: Observable<HomeViewModelOutputAction> { actionSubject.asObserver() }

    public var route: Observable<HomeViewModelRoute> { routeSubject.asObserver() }

    public func viewWillAppear() {
        userBalanceService.update()
    }

    public func viewDidLoad() {
		userInfoRepo.currentUserInfo(params: .init()) { result in // FIXME: remove after testing
			switch result {
			case .success(let entity):
				print("*** HomdeViewModel: entity.statusId: \(entity.statusId ?? -1)")
				print("*** HomeViewModel: suspendTill: \(entity.suspendTill ?? "NIL")")
			case .failure(let error):
				print(error)
			}
		}
        displayEmptyGames()
        showErrorIfNeeded()
        observeLanguageChange()
        observeLayoutChange()

        loadRecentryPlayedGames()
        load(loadingType: .fullScreen)
    }

    private func showErrorIfNeeded() {
        if let error = params.error {
            params.error = nil
            DispatchQueue.main.async { [weak self] in
                self?.show(error: error)
            }
        }
    }

    private func displayEmptyGames() {
        let recentryPlayedSection = AppSectionDataProvider(dataProviders: [recentlyPlayedComponentViewModel])
        let gamesSectionTop = AppSectionDataProvider(dataProviders: [])
        let gamesSectionBottom = AppSectionDataProvider(dataProviders: [loading])

        actionSubject.onNext(.initialize(AppListDataProvider(sectionDataProviders: [placeholderSection, bannerSection, gamesSectionTop, recentryPlayedSection, gamesSectionBottom])))
    }

    public func didLoadNextPage() {
        guard page.hasMore, loadingType == .none else {return}
        load(loadingType: .nextPage)
    }
}
