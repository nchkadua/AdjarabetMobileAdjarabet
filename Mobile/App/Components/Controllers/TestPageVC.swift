//
//  TestPageVC.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import EMPageViewController

public protocol PageViewControllerProtocol {}

class TestPageVC: UIViewController, EMPageViewControllerDataSource, EMPageViewControllerDelegate {
    var pageViewController: EMPageViewController?
    var viewControllers = [UIViewController]()
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate EMPageViewController and set the data source and delegate to 'self'
        let pageViewController = EMPageViewController()

        // Or, for a vertical orientation
        // let pageViewController = EMPageViewController(navigationOrientation: .Vertical)

        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.scrollView.bounces = false

        // Set the initially selected view controller
        // IMPORTANT: If you are using a dataSource, make sure you set it BEFORE calling selectViewController:direction:animated:completion
        let currentViewController = self.viewControllers[0]
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        // Add EMPageViewController to the root view controller
        self.addChild(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0) // Insert the page controller view below the navigation buttons
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
        self.pageViewController?.scrollForward(animated: true, completion: nil)
    }

    public func previous() {
        self.pageViewController?.scrollReverse(animated: true, completion: nil)
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

        return self.viewControllers[indexBefore]
    }

    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let indexAfter = self.viewControllers.index(after: index)

        guard (self.viewControllers.startIndex..<self.viewControllers.endIndex).contains(indexAfter) else {
            return nil
        }

        return self.viewControllers[indexAfter]
    }

    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        currentIndex = viewControllers.firstIndex(of: viewControllers.first ?? UIViewController()) ?? 0
    }
}

extension TestPageVC: UIScrollViewDelegate {
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
