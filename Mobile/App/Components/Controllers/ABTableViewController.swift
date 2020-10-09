//
//  ABTableViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import RxCocoa

public class ABTableViewController: AppTableViewController {
    private let disposeBag = DisposeBag()
    public var isTabBarManagementEnabled: Bool = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(types: [
            PromotionTableViewCell.self
        ])
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
