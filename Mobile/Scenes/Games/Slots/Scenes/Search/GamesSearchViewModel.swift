//
//  GamesSearchViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol GamesSearchViewModel: BaseViewModel, GamesSearchViewModelInput, GamesSearchViewModelOutput, ABCollectionViewModel {
}

public struct GamesSearchViewModelParams {
}

public protocol GamesSearchViewModelInput {
    func viewDidLoad()
    func willPresent()
    func didDismiss()
    func didUpdateQuary(text: String?)
    func didSearch(query: String?)
    
    var emptyStateViewModel: EmptyPageComponentViewModel { get }
}

public protocol GamesSearchViewModelOutput {
    var action: Observable<GamesSearchViewModelOutputAction> { get }
    var route: Observable<GamesSearchViewModelRoute> { get }
    var params: GamesSearchViewModelParams { get }
}

public enum GamesSearchViewModelOutputAction {
    case setLoading(LoadingType)
    case reloadIndexPathes([IndexPath])
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case initialize(AppListDataProvider)
}

public enum GamesSearchViewModelRoute {
    case open(game: Game)
}

public class DefaultGamesSearchViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<GamesSearchViewModelOutputAction>()
    private let routeSubject = PublishSubject<GamesSearchViewModelRoute>()
    public let params: GamesSearchViewModelParams

    @Inject(from: .useCases) private var lobbyGamesUseCase: LobbyGamesUseCase

    private var gamesLoadTask: Cancellable? { willSet { gamesLoadTask?.cancel() } }

    public var querySubject = PublishSubject<String?>()
    private var query: String?
    private var page: PageDescription = .init()
    private var games: AppCellDataProviders = []
    public let loading = DefaultLoadingComponentViewModel(params: .init(tintColor: .secondaryText(), height: 55))

    private var loadingType: LoadingType = .none {
        didSet {
            guard loadingType != oldValue else {return}

            actionSubject.onNext(.setLoading(loadingType))

            let isNextPage = loadingType == .nextPage
            loading.set(isLoading: isNextPage)
            let indexPath = IndexPath(item: games.count, section: 0)
            actionSubject.onNext(.reloadIndexPathes([indexPath]))
        }
    }

    private var defaultAppListDataProvider: AppListDataProvider {
        AppListDataProvider(sectionDataProviders: [AppSectionDataProvider(dataProviders: [loading])])
    }

    public init(params: GamesSearchViewModelParams) {
        self.params = params
    }

    private func load(query: String?, loadingType: LoadingType) {
        self.loadingType = loadingType
        self.query = query ?? ""

        gamesLoadTask = lobbyGamesUseCase.execute(request: .init(page: page.current, itemsPerPage: page.itemsPerPage, searchTerm: query)) { result in
            defer { self.loadingType = .none }

            switch result {
            case .success(let params):
                let viewModels: [DefaultGameLauncherComponentViewModel] = params.games.compactMap { [weak self] in
                    guard let self = self else {return nil}

                    let vm = DefaultGameLauncherComponentViewModel(game: $0)
                    vm.action.subscribe(onNext: { action in
                        switch action {
                        case .didSelect(let model, _): self.routeSubject.onNext(.open(game: model.params.game))
                        default: break
                        }
                    }).disposed(by: self.disposeBag)
                    return vm
                }

                self.appendPage(games: viewModels)
            case .failure(let error):
                self.show(error: error)
            }
        }
    }

    private func appendPage(games: AppCellDataProviders) {
        let offset = self.games.count

        self.page.setNextPage()
        self.page.configureHasMore(forNumberOfItems: games.count)

        self.games.append(contentsOf: games)

        let indexPathes = games.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
        actionSubject.onNext(.reloadItems(items: games, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    }

    private func update(query: String?) {
        page.reset()
        games.removeAll()
        actionSubject.onNext(.initialize(defaultAppListDataProvider))

        load(query: query, loadingType: .fullScreen)
    }
}

extension DefaultGamesSearchViewModel: GamesSearchViewModel {
    public var emptyStateViewModel: EmptyPageComponentViewModel {
        DefaultEmptyPageComponentViewModel.init(params: .init(
                                                    icon: R.image.promotions.casino_icon()!, // TODO: EmptyState: change with original icon,
                                                    title: "",
                                                    description: R.string.localization.search_empty_state_description()))
    }
    
    public var action: Observable<GamesSearchViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<GamesSearchViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.initialize(defaultAppListDataProvider))
    }

    public func willPresent() {
        querySubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.didSearch(query: query)
            })
            .disposed(by: disposeBag)

        actionSubject.onNext(.setLoading(.fullScreen))
        didSearch(query: nil)
    }

    public func didDismiss() {
        disposeBag = DisposeBag()
        gamesLoadTask?.cancel()
        page.reset()
        games.removeAll()
        actionSubject.onNext(.initialize(defaultAppListDataProvider))
        loadingType = .none
    }

    public func didUpdateQuary(text: String?) {
        querySubject.onNext(text)
    }

    public func didSearch(query: String?) {
        update(query: query)
    }

    public func didLoadNextPage() {
        guard page.hasMore, loadingType == .none else {return}
        load(query: query, loadingType: .nextPage)
    }
}
