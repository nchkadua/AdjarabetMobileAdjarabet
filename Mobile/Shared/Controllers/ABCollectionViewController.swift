//
//  ABCollectionViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol ABCollectionViewModel {
    func didLoadNextPage()
}

public class ABCollectionViewController: AppCollectionViewController, UICollectionViewDelegateFlowLayout {
    public var viewModel: ABCollectionViewModel?

    private let disposeBag = DisposeBag()
    private var numItemsInEmptyCollection = 0
    public var isTabBarManagementEnabled: Bool = false

    private lazy var emptyStateView: EmptyPageComponentView = {
        let emptyStateView = EmptyPageComponentView()
        self.collectionView.backgroundView = emptyStateView
        emptyStateView.hide()
        return emptyStateView
    }()

    public var safeAreaRect: CGRect {
        collectionView.bounds
            .inset(by: flowLayout?.sectionInset ?? .zero)
            .inset(by: view.safeAreaInsets)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(types: [
            RecentlyPlayedCollectionViewCell.self,
            PlayedGameLauncherCollectionViewCell.self,
            GameLauncherCollectionViewCell.self,
            LoadingCollectionViewCell.self,
            GameLauncherGridCollectionViewCell.self,
            EmptyCollectionViewCell.self,
            ABSliderCollectionViewCell.self,
            LayoutChooserCollectionViewCell.self
        ])

        setupCollectionView()
        setupFlowLayout()
    }

    public func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
    }

    public func setupFlowLayout() {
        flowLayout?.scrollDirection = .vertical
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.sectionInset = .zero
    }

    public func configureEmptyState(with viewModel: EmptyPageComponentViewModel, numItemsInEmptyCollection: Int = 0) -> Self {
        self.numItemsInEmptyCollection = numItemsInEmptyCollection
        emptyStateView.setAndBind(viewModel: viewModel)
        return self
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection = super.collectionView(collectionView, numberOfItemsInSection: section)
        emptyStateView.isHidden = numberOfItemsInSection > numItemsInEmptyCollection
        return numberOfItemsInSection
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.numberOfSections - 1 == indexPath.section && collectionView.numberOfItems(inSection: indexPath.section) - 10 == indexPath.item {
            viewModel?.didLoadNextPage()
        }

        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellHeightProviding = dataProvider?[indexPath] as? CellHeighProvidering else {
            return .zero
        }

        return cellHeightProviding.size(for: collectionView.bounds, safeArea: safeAreaRect, minimumLineSpacing: 0, minimumInteritemSpacing: 0)
    }

    // MARK: TabBar management
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performCheck(for: translation)
    }

    public override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetPoint = targetContentOffset.pointee
        let currentPoint = scrollView.contentOffset

        if targetPoint.y > currentPoint.y {
            hideFloatingTabBar()
        } else {
            showFloatingTabBar()
        }
    }

    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performCheck(for: translation)
    }

    public func performCheck(for translation: CGPoint) {
        if translation.y >= 0 {
            showFloatingTabBar()
        } else {
            hideFloatingTabBar()
        }
    }

    public func hideFloatingTabBar() {
        return  // Floating tab bar removed
        // guard isTabBarManagementEnabled else {return}
        // mainTabBarViewController?.hideFloatingTabBar()
    }

    public func showFloatingTabBar() {
        return  // Floating tab bar removed
        // guard isTabBarManagementEnabled else {return}
        // mainTabBarViewController?.showFloatingTabBar()
    }
}

public extension AppCollectionViewController {
    func reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath]) {
        collectionView.performBatchUpdates({
            deletionIndexPathes.reversed().forEach {
                dataProvider?.sectionDataProviders[$0.section].remove(at: $0.item)
            }
            collectionView?.deleteItems(at: deletionIndexPathes)

            if let first = insertionIndexPathes.first {
                items.reversed().forEach {
                    dataProvider?.sectionDataProviders[first.section].insert($0, at: first.item)
                }
                collectionView?.insertItems(at: insertionIndexPathes)
            }
        }, completion: nil)
    }
}
