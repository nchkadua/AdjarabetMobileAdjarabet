//
//  GameSearchViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class GamesSearchViewController: ABViewController {
    var viewModel: GamesSearchViewModel = DefaultGamesSearchViewModel(params: .init())
    public lazy var collectionViewController = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        .configureEmptyState(with: viewModel.emptyStateViewModel, numItemsInEmptyCollection: 1)
        .enableEmptyState()

    // shimmer loader
    private lazy var loader: GamesListLoader = {
        collectionViewController.addDefaultGamesListLoader(isRecentlyPlayedEnabled: false)
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
        addNotificationCenterObservers()
    }
    
    private func addNotificationCenterObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc public override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewModel.keyboardHeight = keyboardHeight
        }
    }

    // MARK: Binding
    private func bind(to viewModel: GamesSearchViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: GamesSearchViewModelOutputAction) {
        switch action {
        case .configureEmptyState(let emptyStateViewModel):
            collectionViewController.configureEmptyState(with: emptyStateViewModel, numItemsInEmptyCollection: 1)
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
        view.addSubview(collectionViewController.view)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        collectionViewController.view.pin(to: view)
        view.setBackgorundColor(to: .primaryBg())
        collectionViewController.setBaseBackgroundColor()
        collectionViewController.collectionView.alwaysBounceVertical = true
        collectionViewController.collectionView.keyboardDismissMode = .interactive
        collectionViewController.view.backgroundColor = view.backgroundColor
        collectionViewController.viewModel = viewModel
    }
    
}
