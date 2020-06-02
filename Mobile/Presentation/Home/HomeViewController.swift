//
//  HomeViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class HomeViewController: UIViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    private lazy var floatingTabBarManager = FloatingTabBarManager(viewController: self)
    private lazy var collectionViewController = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var searchCollectionViewController = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var searchController = UISearchController(searchResultsController: nil)

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func bind(to viewModel: HomeViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: HomeViewModelOutputAction) {
        switch action {
        case .languageDidChange:
            languageDidChange()
        case .initialize(let appListDataProvider):
            collectionViewController.dataProvider = appListDataProvider
        case .reloadItems(let items, let insertionIndexPathes, let deletionIndexPathes):
            collectionViewController.collectionView.performBatchUpdates({
                deletionIndexPathes.reversed().forEach {
                    collectionViewController.dataProvider?.first?.remove(at: $0.item)
                }
                collectionViewController.collectionView.deleteItems(at: deletionIndexPathes)

                items.reversed().forEach {
                    collectionViewController.dataProvider?.first?.insert($0, at: insertionIndexPathes.first!.item)
                }
                collectionViewController.collectionView.insertItems(at: insertionIndexPathes)
            }, completion: nil)
        case .reloadIndexPathes(let indexPathes):
            UIView.performWithoutAnimation {
                collectionViewController.collectionView.reloadItems(at: indexPathes)
            }
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupNavigationItem()
        setupSearchViewController()

        setupCollectionViewController()
        setupSearchCollectionViewController()
        setupWhen(mainCollectionViewIsVisible: true, animated: false)
    }

    private func setupNavigationItem() {
        makeLeftBarButtonItemTitle(to: R.string.localization.home_page_title.localized())
        navigationItem.rightBarButtonItem = makeBalanceBarButtonItem().barButtonItem
    }

    private func setupCollectionViewController() {
        collectionViewController.viewModel = viewModel

        collectionViewController.isTabBarManagementEnabled = true
        add(child: collectionViewController)

        let played: [PlayedGameLauncherCollectionViewCellDataProvider] = (1...20).map {
            let params = PlayedGameLauncherComponentViewModelParams(
                id: UUID().uuidString,
                coverUrl: DummyData.imageUrls.randomElement()!,
                name: "Game name \($0)",
                lastWon: Bool.random() ? nil : "Last won $ \(Int.random(in: 5...100))")
            let viewModel = DefaultPlayedGameLauncherComponentViewModel(params: params)
            return viewModel
        }

        let params = RecentlyPlayedComponentViewModelParams(
            id: UUID().uuidString,
            title: R.string.localization.recently_played,
            buttonTitle: R.string.localization.view_all,
            playedGames: played)
        let recentryPlayed = DefaultRecentlyPlayedComponentViewModel(params: params)
        recentryPlayed.action.subscribe(onNext: { action in
            self.didReceive(action: action)
        }).disposed(by: disposeBag)

        collectionViewController.dataProvider = ([recentryPlayed]).makeList()
    }

    private func setupSearchCollectionViewController() {
        add(child: searchCollectionViewController)

        searchCollectionViewController.collectionView.alwaysBounceVertical = true
        searchCollectionViewController.collectionView.keyboardDismissMode = .interactive
        searchCollectionViewController.view.backgroundColor = view.backgroundColor

        let items: AppCellDataProviders = (1...20).map {
            let params = GameLauncherComponentViewModelParams(
                id: UUID().uuidString,
                coverUrl: DummyData.imageUrls.randomElement()!,
                name: "Game name \($0)",
                category: "category \($0)",
                jackpotAmount: Bool.random() ? nil : "$ 50,2319.98")
            let viewModel = DefaultGameLauncherComponentViewModel(params: params)
            viewModel.action.subscribe(onNext: { [weak self] action in
                self?.didReceive(action: action)
            }).disposed(by: disposeBag)
            return viewModel
        }

        searchCollectionViewController.dataProvider = items.makeList()
    }

    private func setupSearchViewController() {
        self.setupStandardSearchViewController(searchController: searchController)

        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
    }

    private func setupWhen(mainCollectionViewIsVisible: Bool, animated animate: Bool) {
        let alpha: CGFloat = mainCollectionViewIsVisible ? 1 : 0
        UIView.animate(withDuration: animate ? 0.3 : 0) {
            self.collectionViewController.view.alpha = alpha
            self.searchCollectionViewController.view.alpha = 1 - alpha
        }

        mainCollectionViewIsVisible ? mainTabBarViewController?.showFloatingTabBar() : mainTabBarViewController?.hideFloatingTabBar()
    }

    private func languageDidChange() {
        setupNavigationItem()
        searchController.searchBar.placeholder = R.string.localization.home_search_placeholder.localized()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = R.string.localization.cancel.localized()

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: DesignSystem.Color.neutral100().value,
            .font: DesignSystem.Typography.p.description.font
        ]

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: DesignSystem.Color.neutral100().value,
            .font: DesignSystem.Typography.p.description.font
        ], for: .normal)
    }

    // MARK: Reactive methods
    private func didReceive(action: RecentlyPlayedComponentViewModelOutputAction) {
        switch action {
        case .didSelectPlayedGame(let vm, _): showAlert(title: vm.params.name)
        case .didSelectViewAll: showAlert(title: "View All")
        default: break
        }
    }

    private func didReceive(action: GameLauncherComponentViewModelOutputAction) {
        switch action {
        case .didSelect(let vm, _):
            let alert = UIAlertController(title: vm.params.name, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default: break
        }
    }
}

extension HomeViewController: CommonBarButtonProviding { }

// MARK: UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        print(#function, searchController.searchBar.text ?? "")
  }
}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}

// MARK: UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        setupWhen(mainCollectionViewIsVisible: false, animated: true)
    }

    public func didPresentSearchController(_ searchController: UISearchController) {
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        setupWhen(mainCollectionViewIsVisible: true, animated: true)
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
    }
}
