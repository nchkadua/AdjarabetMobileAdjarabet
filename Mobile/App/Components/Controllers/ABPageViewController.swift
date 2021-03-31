//
//  ABPageViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

class ABPageViewController: UIPageViewController {
    // MARK: init methods
    required override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties
    public var orderedViewControllers: [UIViewController]? {
        didSet {
            if let firstViewController = self.orderedViewControllers?.first {
                setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: Setup methods
    private func setup() {
        view.setBackgorundColor(to: .secondaryBg())
        dataSource = self
    }

    // MARK: Public methods
    public func jumgToViewController(at index: Int, direction: NavigationDirection = .forward) {
        if let vc = self.orderedViewControllers?[index] {
            setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }

    public func jump(to viewController: UIViewController, direction: NavigationDirection = .forward, animated: Bool = true) {
        setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
    }

    public func setSwipeEnabled(_ enable: Bool) {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = enable
            }
        }
    }
}

// MARK: PageViewController DataSource
extension ABPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers?.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        return orderedViewControllers?[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers?.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers?.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        return orderedViewControllers?[nextIndex]
    }
}
