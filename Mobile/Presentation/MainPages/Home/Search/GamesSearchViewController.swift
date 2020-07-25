//
//  GameSearchViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class GamesSearchViewController: UISearchController {
    private let disposeBag = DisposeBag()
    public var viewModel: GamesSearchViewModel!
    public lazy var collectionViewController = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

    // shimmer loader
    private lazy var loader: GamesListLoader = {
        collectionViewController.addDefaultGamesListLoader(isRecentlyPlayedEnabled: false)
    }()

    public init(viewModel: GamesSearchViewModel, searchResultsController: UIViewController? = nil) {
        self.viewModel = viewModel
        super.init(searchResultsController: searchResultsController)
    }

    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Binding
    private func bind(to viewModel: GamesSearchViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: GamesSearchViewModelOutputAction) {
        switch action {
        case .setLoading(let loadingType):
            UIView.animate(withDuration: 0.3) { self.loader.alpha = loadingType == .fullScreen ? 1 : 0 }
        case .initialize(let appListDataProvider):
            collectionViewController.dataProvider = appListDataProvider
            collectionViewController.collectionView.setContentOffset(.zero, animated: false)
        case .reloadItems(let items, let insertions, let deletions):
            collectionViewController.reloadItems(items: items, insertionIndexPathes: insertions, deletionIndexPathes: deletions)
        case .reloadIndexPathes(let indexPathes):
            UIView.performWithoutAnimation {
                collectionViewController.collectionView.reloadItems(at: indexPathes)
            }
        }
    }

    // MARK: Setup methods
    private func setup() {
        setupCollectionViewController()
    }

    private func setupCollectionViewController() {
        collectionViewController.setBaseBackgorundColor()
        collectionViewController.collectionView.alwaysBounceVertical = true
        collectionViewController.collectionView.keyboardDismissMode = .interactive
        collectionViewController.view.backgroundColor = view.backgroundColor
        collectionViewController.viewModel = viewModel
    }
}
