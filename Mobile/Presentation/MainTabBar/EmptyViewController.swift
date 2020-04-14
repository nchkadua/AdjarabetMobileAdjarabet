//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class EmptyViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    public override func viewDidLoad() {
        scrollView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    @objc func push() {
        let v1 = R.storyboard.mainTabBar().instantiate(controller: EmptyViewController.self)!
        v1.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(v1, animated: true)
    }
}

extension EmptyViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performHeaderCheck(translation: translation)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetPoint = targetContentOffset.pointee
        let currentPoint = scrollView.contentOffset

        if targetPoint.y > currentPoint.y {
            hideHeader()
        } else {
            showHeader()
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performHeaderCheck(translation: translation)
        print(#function)
    }

    func performHeaderCheck(translation: CGPoint) {
        if translation.y >= 0 {
            showHeader()
        } else {
            hideHeader()
        }
    }

    func hideHeader() {
        let tabBar = self.tabBarController as? MainTabBarViewController
        tabBar?.hideFloatingTabBar()
    }

    func showHeader() {
        let tabBar = self.tabBarController as? MainTabBarViewController
        tabBar?.showFloatingTabBar()
    }
}
