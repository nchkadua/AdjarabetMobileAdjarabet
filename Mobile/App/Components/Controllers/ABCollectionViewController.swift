//
//  ABCollectionViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class ABCollectionViewController: AppCollectionViewController, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()
    public var isTabBarManagementEnabled: Bool = false

    public var safeAreaRect: CGRect {
        collectionView.bounds
            .inset(by: flowLayout?.sectionInset ?? .zero)
            .inset(by: view.safeAreaInsets)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(types: [
            GameLauncherCollectionViewCell.self
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
        guard isTabBarManagementEnabled else {return}
        mainTabBarViewController?.hideFloatingTabBar()
    }

    public func showFloatingTabBar() {
        guard isTabBarManagementEnabled else {return}
        mainTabBarViewController?.showFloatingTabBar()
    }
}
