//
//  ABPageViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import EMPageViewController

public protocol PageViewControllerProtocol {}

class ABPageViewController: UIViewController, EMPageViewControllerDataSource, EMPageViewControllerDelegate {
    public var pageViewController: EMPageViewController?
    public var viewControllers = [UIViewController]()

    private var currentIndex = 0
    private var currentViewController: UIViewController!
    private var isAnimating = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let pageViewController = EMPageViewController()

        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.scrollView.bounces = false

        if !viewControllers.isEmpty {
            currentViewController = self.viewControllers[0]
            pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        }

        self.addChild(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0)
        pageViewController.didMove(toParent: self)

        self.pageViewController = pageViewController
    }

    public required init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func next() {
        guard !isAnimating else {return}

        isAnimating = true
        self.pageViewController?.scrollForward(animated: true, completion: {_ in
            self.isAnimating = false
        })
    }

    public func previous() {
        guard !isAnimating else {return}

        isAnimating = true
        self.pageViewController?.scrollReverse(animated: true, completion: {_ in
            self.isAnimating = false
        })
    }

    public func jump(to viewController: UIViewController, direction: EMPageViewControllerNavigationDirection, animated: Bool = true) {
        pageViewController?.selectViewController(viewController, direction: direction, animated: animated, completion: nil)
    }

    public func setSwipeEnabled(_ enable: Bool) {
        pageViewController?.scrollView.isScrollEnabled = enable
    }

    // MARK: - EMPageViewController Data Source
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let indexBefore = self.viewControllers.index(before: index)

        guard (self.viewControllers.startIndex..<self.viewControllers.endIndex).contains(indexBefore) else {
            return nil
        }

        currentViewController = self.viewControllers[indexBefore]
        return currentViewController
    }

    // MARK: - EMPageViewController Delegate
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let indexAfter = self.viewControllers.index(after: index)

        guard (self.viewControllers.startIndex..<self.viewControllers.endIndex).contains(indexAfter) else {
            return nil
        }

        currentViewController = self.viewControllers[indexAfter]
        return currentViewController
    }

    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        currentIndex = viewControllers.firstIndex(of: viewControllers.first ?? currentViewController) ?? 0
        pageViewController.scrollView.isScrollEnabled = true
    }
}

extension ABPageViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == viewControllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == viewControllers.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}
