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

        setBaseBackgorundColor()
        setLeftBarButtonItemTitle(to: R.string.localization.home_page_title.localized())
        setupAuthButtonActions()
        setupSearchViewController()

//        setupScrollView()
        setupCollectionViewController()
        setupSearchCollectionViewController()
        setupWhen(mainCollectionViewIsVisible: true, animated: false)
    }

    // MARK: Setup methods
    private func setupCollectionViewController() {
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
            title: "Recentry Played",
            buttonTitle: "View all",
            playedGames: played)
        let recentryPlayed = DefaultRecentlyPlayedComponentViewModel(params: params)
        recentryPlayed.action.subscribe(onNext: { action in
            self.didReceive(action: action)
        }).disposed(by: disposeBag)

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

        collectionViewController.dataProvider = ([recentryPlayed] + items).makeList()
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

    private func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.pinSafely(in: view)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 3)

        floatingTabBarManager.observe(scrollView: scrollView)
    }

    private func setupSearchViewController() {
        self.setupStandardSearchViewController(searchController: searchController)

        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
    }

    private func setupAuthButtonActions() {
        let items = setAuthBarButtonItems()

        items.joinNow.button.addTarget(self, action: #selector(joinNowButtonDidTap), for: .touchUpInside)
        items.login.button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    private func setupProfilButton() {
        setProfileBarButtonItem(text: "₾ 0.00")
    }

    private func setupWhen(mainCollectionViewIsVisible: Bool, animated animate: Bool) {
        let alpha: CGFloat = mainCollectionViewIsVisible ? 1 : 0
        UIView.animate(withDuration: animate ? 0.3 : 0) {
            self.collectionViewController.view.alpha = alpha
            self.searchCollectionViewController.view.alpha = 1 - alpha
        }

        mainCollectionViewIsVisible ? mainTabBarViewController?.showFloatingTabBar() : mainTabBarViewController?.hideFloatingTabBar()
    }

    // MARK: Reactive methods
    private func didReceive(action: RecentlyPlayedComponentViewModelOutputAction) {
        switch action {
        case .didSelectPlayedGame(let vm, _):
            let alert = UIAlertController(title: vm.params.name, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        case .didSelectViewAll(let vm):
            print(vm)
            let alert = UIAlertController(title: "View All", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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

    // MARK: Action methods
    @objc public func joinNowButtonDidTap() {
        let alert = UIAlertController(title: R.string.localization.join_now.localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc public func loginButtonDidTap() {
        let alert = UIAlertController(title: R.string.localization.login.localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
