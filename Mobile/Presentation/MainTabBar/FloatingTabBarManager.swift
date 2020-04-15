//
//  A.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class FloatingTabBarManager: NSObject, UIScrollViewDelegate {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performHeaderCheck(translation: translation)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetPoint = targetContentOffset.pointee
        let currentPoint = scrollView.contentOffset

        if targetPoint.y > currentPoint.y {
            hideFloatingTabBar()
        } else {
            showFloatingTabBar()
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performHeaderCheck(translation: translation)
    }

    func performHeaderCheck(translation: CGPoint) {
        if translation.y >= 0 {
            showFloatingTabBar()
        } else {
            hideFloatingTabBar()
        }
    }

    func hideFloatingTabBar() {
        viewController?.mainTabBarViewController?.hideFloatingTabBar()
    }

    func showFloatingTabBar() {
        viewController?.mainTabBarViewController?.showFloatingTabBar()
    }
}
