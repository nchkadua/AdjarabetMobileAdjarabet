//
//  A.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class FloatingTabBarManager: NSObject, UIScrollViewDelegate {
    private let disposeBag = DisposeBag()
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func observe(scrollView: UIScrollView) {
        scrollView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performCheck(for: translation)
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
        // viewController?.mainTabBarViewController?.hideFloatingTabBar()
    }

    public func showFloatingTabBar() {
        return  // Floating tab bar removed
        // viewController?.mainTabBarViewController?.showFloatingTabBar()
    }
}
