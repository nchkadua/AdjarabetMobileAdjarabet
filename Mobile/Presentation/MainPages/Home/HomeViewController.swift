//
//  HomeViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import CoreLocation

public class HomeViewController: UIViewController {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    @Inject(from: .viewModels) private var viewModel: HomeViewModel
    public var searchViewModel: GamesSearchViewModel { searchController.viewModel }
    public lazy var navigator = HomeNavigator(viewController: self)
    private lazy var collectionViewController = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var searchController = GamesSearchViewController(viewModel: DefaultGamesSearchViewModel(params: .init()))
    let repo: PostLoginRepository = DefaultPostLoginRepository()
    // shimmer loader
    private lazy var loader: GamesListLoader = {
        let l = addDefaultGamesListLoader(isRecentlyPlayedEnabled: true)
        l.backgroundColor = view.backgroundColor
        return l
    }()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        generateAccessibilityIdentifiers()
//        addLayoutButton()
        repo.userLoggedIn(params: .init(fromRegistration: false)) { result in
            switch result {
            case .success(let entity):
                print("userLoggedIn:", entity)
            case .failure(let error):
                print(error)
            }
        }
    }

    // TEST BUTTON
    private func addLayoutButton() {
        let button = UIButton(type: .contactAdd)
        button.addTarget(self, action: #selector(changeLayout), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        button.center = view.center
    }

    @objc func changeLayout() {
        viewModel.layoutChangeTapped()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }

    // MARK: Binding
    private func bind(to viewModel: HomeViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)

        searchViewModel.route.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: HomeViewModelOutputAction) {
        switch action {
        case .setLoading(let loadingType):
            UIView.animate(withDuration: 0.3) { self.loader.alpha = loadingType == .fullScreen ? 1 : 0 }
        case .languageDidChange: languageDidChange()
        case .initialize(let appListDataProvider):
            collectionViewController.dataProvider = appListDataProvider
        case .reloadItems(let items, let insertions, let deletions):
            collectionViewController.reloadItems(items: items, insertionIndexPathes: insertions, deletionIndexPathes: deletions)
        case .reloadIndexPathes(let indexPathes):
            UIView.performWithoutAnimation {
                collectionViewController.collectionView.reloadItems(at: indexPathes)
            }
        }
    }

    private func didReceive(action: HomeViewModelRoute) {
        switch action {
        case .openGame: navigator.navigate(to: .game, animated: true)
        }
    }

    private func didReceive(action: GamesSearchViewModelRoute) {
        switch action {
        case .openGame(let title): showAlert(title: "Welcome to \(title)")
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupSearchViewController()

        setupCollectionViewController()
        setupWhen(mainCollectionViewIsVisible: true, animated: false)
    }

    private func setupNavigationItems() {
        makeAdjarabetLogo()

        let profileButtonGroup = makeBalanceBarButtonItem()
        navigationItem.rightBarButtonItem = profileButtonGroup.barButtonItem
        profileButtonGroup.button.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
    }

    @objc private func openProfile() {
        navigator.navigate(to: .profile, animated: true)
    }

    private func setupCollectionViewController() {
        collectionViewController.viewModel = viewModel

        collectionViewController.isTabBarManagementEnabled = true
        add(child: collectionViewController)
    }

    private func setupSearchViewController() {
        setupStandardSearchViewController(searchController)
        add(child: searchController.collectionViewController)
        setupSearchBar()

        searchController.delegate = self

        searchController.searchBar.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.searchViewModel.didUpdateQuary(text: $0)
            }).disposed(by: disposeBag)
    }

    private func setupSearchBar() {
        let searchBar = searchController.searchBar

        for item in searchBar.searchTextField.subviews where item.className == "_UISearchBarSearchFieldBackgroundView" {
            item.removeAllSubViews()
        }

        searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .search)
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        searchBar.setImage(R.image.shared.search(), for: .search, state: .normal)
        searchBar.searchTextField.leftView?.setTintColor(to: .secondaryText())
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 4, vertical: 0)

        searchBar.searchTextField.setTextColor(to: .primaryText())
        searchBar.searchTextField.setFont(to: .footnote(fontCase: .lower))
        searchBar.searchTextField.setBackgorundColor(to: .querternaryFill())
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true

        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: R.string.localization.home_search_placeholder.localized(), attributes: [
            .foregroundColor: DesignSystem.Color.secondaryText().value,
            .font: DesignSystem.Typography.footnote(fontCase: .lower).description.font
        ])

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = R.string.localization.cancel.localized()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: DesignSystem.Color.secondaryText().value,
            .font: DesignSystem.Typography.footnote(fontCase: .lower).description.font
        ], for: .normal)
    }

    private func setupWhen(mainCollectionViewIsVisible: Bool, animated animate: Bool) {
        let alpha: CGFloat = mainCollectionViewIsVisible ? 1 : 0
        UIView.animate(withDuration: animate ? 0.3 : 0) {
            self.collectionViewController.view.alpha = alpha
            self.searchController.collectionViewController.view.alpha = 1 - alpha
        }

        mainCollectionViewIsVisible ? mainTabBarViewController?.showFloatingTabBar() : mainTabBarViewController?.hideFloatingTabBar()
    }

    private func languageDidChange() {
        setupNavigationItems()
        setupSearchBar()
    }
}

extension HomeViewController: CommonBarButtonProviding { }

// MARK: UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        setupWhen(mainCollectionViewIsVisible: false, animated: true)
        searchViewModel.willPresent()
    }

    public func didPresentSearchController(_ searchController: UISearchController) {
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        setupWhen(mainCollectionViewIsVisible: true, animated: true)
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        searchViewModel.didDismiss()
    }
}

extension HomeViewController: Accessible {}
