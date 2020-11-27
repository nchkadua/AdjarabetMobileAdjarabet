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
    }

    // MARK: Public methods
    public func jumgToViewController(at index: Int) {
        switch index {
        case 0:
            if let vc = self.orderedViewControllers?.first {
                setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
            }
        case 1:
            if let vc = self.orderedViewControllers?[1] {
                setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            }
        default:
            break
        }
    }
}
