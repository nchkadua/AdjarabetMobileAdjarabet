//
//  HomeViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import CoreLocation

public class HomeViewController: ABViewController, PageViewControllerProtocol {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: HomeViewModel
    public var searchViewModel: GamesSearchViewModel { searchController.viewModel }
    public lazy var navigator = HomeNavigator(viewController: self)
    private lazy var collectionViewController = HomeViewCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var searchController = GamesSearchViewController()

    @IBOutlet private weak var header: HomeHeaderView!

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
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
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
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.loader.alpha = loadingType == .fullScreen ? 1 : 0
                self?.loader.isHidden = loadingType != .fullScreen
            }
        case .languageDidChange: languageDidChange()
        case .initialize(let appListDataProvider):
            collectionViewController.dataProvider = appListDataProvider
        case .reloadItems(let items, let insertions, let deletions):
            collectionViewController.reloadItems(items: items, insertionIndexPathes: insertions, deletionIndexPathes: deletions)
        case .reloadIndexPathes(let indexPathes):
            UIView.performWithoutAnimation {
                collectionViewController.collectionView.reloadItems(at: indexPathes)
            }
        case .replaceSection(let index, let dataProvider):
            collectionViewController.replace(section: index, with: dataProvider)
        }
    }

    private func didReceive(action: HomeViewModelRoute) {
        switch action {
        case .open(let game):
            navigator.navigate(to: .game(game), animated: true)
        }
    }

    private func didReceive(action: GamesSearchViewModelRoute) {
        switch action {
        case .open(let game):
            navigator.navigate(to: .game(game), animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupSearchViewController()
        hideNavBar()
        header.delegate = self
        setupCollectionViewController()
        setupWhen(mainCollectionViewIsVisible: true, animated: false)
    }

    private func setupNavigationItems() {
        let balanceButton = header.balanceButton
        balanceButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        balanceButton.accessibilityIdentifier = "profileButton"
    }

    @objc private func openProfile() {
        navigator.navigate(to: .profile, animated: true)
    }

    private func setupCollectionViewController() {
        guard let collectionView = collectionViewController.collectionView
        else { return }

        collectionViewController.viewModel = viewModel
        collectionViewController.isTabBarManagementEnabled = true
        collectionViewController.delegate = self

        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinSafely(to: view)
    }

    private func setupSearchViewController() {
        add(child: searchController)
        guard let search = searchController.view
        else { return }
        view.addSubview(search)
        search.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            search.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            search.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            search.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            search.topAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        header.bar.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.searchViewModel.didUpdateQuary(text: $0)
            }).disposed(by: disposeBag)
    }

    private func setupWhen(mainCollectionViewIsVisible: Bool, animated animate: Bool) {
        let alpha: CGFloat = mainCollectionViewIsVisible ? 1 : 0
        UIView.animate(withDuration: animate ? 0.3 : 0) {
            self.collectionViewController.view.alpha = alpha
            self.searchController.collectionViewController.view.alpha = 1 - alpha
        }
        searchController.view.isHidden = mainCollectionViewIsVisible
        // mainCollectionViewIsVisible ? mainTabBarViewController?.showFloatingTabBar() : mainTabBarViewController?.hideFloatingTabBar()
    }

    private func languageDidChange() {
        // TODO: handle language change
    }
}

extension HomeViewController: CommonBarButtonProviding { }

extension HomeViewController: HomeHeaderViewDelegate {
    func didFocus() {
        setupWhen(mainCollectionViewIsVisible: false, animated: true)
        searchViewModel.willPresent()
    }

    func didUnfocus() {
        setupWhen(mainCollectionViewIsVisible: true, animated: true)
        searchViewModel.didDismiss()
    }
}

extension HomeViewController: Accessible {}

extension HomeViewController: HomeViewCollectionViewControllerDelegate {
    func placeholderAppeared() {
        header.scrolledUp()
    }

    func placeholderDisappeared() {
        header.scrolledDown()
    }
}

// MARK: - HomeViewCollectionViewController
protocol HomeViewCollectionViewControllerDelegate: AnyObject {
    func placeholderAppeared()
    func placeholderDisappeared()
}

class HomeViewCollectionViewController: ABCollectionViewController {
    weak var delegate: HomeViewCollectionViewControllerDelegate?

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            delegate?.placeholderAppeared()
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            delegate?.placeholderDisappeared()
        }
    }

    func replace(section index: Int, with dataProvider: AppSectionDataProvider) {
        self.dataProvider?.remove(at: index)
        self.dataProvider?.insert(dataProvider, at: index)
    }
}
