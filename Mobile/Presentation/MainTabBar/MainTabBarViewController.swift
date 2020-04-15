//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class MainTabBarViewController: UITabBarController {
    private var tabBarTopConstraint: NSLayoutConstraint!

    private lazy var tabBarStackView: UIStackView = {
        let sw = UIStackView()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.alignment = .fill
        sw.axis = .horizontal
        sw.distribution = .fillEqually
        sw.isLayoutMarginsRelativeArrangement = true
        sw.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return sw
    }()

    private var tabBarButtons: [TabBarButton] {
        tabBarStackView.arrangedSubviews.compactMap { $0 as? TabBarButton }
    }

    public var animationDuration: TimeInterval { 0.3 }

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        delegate = self
        viewControllers = makeViewControllers()

        setupTabBar()
        setupFloatingTabBar()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.isHidden = true
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.isHidden = true
    }

    public override var selectedIndex: Int {
        get {
            return super.selectedIndex
        }
        set {
            if (0..<tabBarButtons.count).contains(super.selectedIndex) {
                tabBarButtons[super.selectedIndex].tintColor = tabBar.unselectedItemTintColor
            }

            super.selectedIndex = newValue

            if (0..<tabBarButtons.count).contains(super.selectedIndex) {
                tabBarButtons[super.selectedIndex].tintColor = tabBar.tintColor
            }
        }
    }

    public func hideFloatingTabBar() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.tabBarTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }

    public func showFloatingTabBar() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.tabBarTopConstraint.isActive = false
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }

    private func makeViewControllers() -> [UIViewController] {
        let v1 = R.storyboard.home().instantiate(controller: HomeViewController.self)!
        let v2 = R.storyboard.sports().instantiate(controller: SportsViewController.self)!
        let v3 = R.storyboard.promotions().instantiate(controller: PromotionsViewController.self)!
        let v4 = R.storyboard.notifications().instantiate(controller: NotificationsViewController.self)!

        v1.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.home(), selectedImage: nil)
        v2.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.sports(), selectedImage: nil)
        v3.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.promotions(), selectedImage: nil)
        v4.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.notification(), selectedImage: nil)

        return [v1, v2, v3, v4].map { $0.wrap(in: AppNavigationController.self) }
    }

    private func setupTabBar() {
        tabBar.tintColor = DesignSystem.Color.secondary400
        tabBar.unselectedItemTintColor = DesignSystem.Color.neutral100
        tabBar.barTintColor = .clear
        tabBar.isTranslucent = true
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderColor = nil
        tabBar.layer.borderWidth = 0
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = DesignSystem.Color.neutral600
        tabBar.isHidden = true
    }

    private func setupFloatingTabBar() {
        let wrapperView = AppShadowView()

        wrapperView.shadowColor = DesignSystem.Color.neutral900
        wrapperView.shadowOffset = .init(width: 0, height: 5)
        wrapperView.shadowOpacity = 0.1
        wrapperView.shadowBlur = 5

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = DesignSystem.Color.neutral600
        wrapperView.hasSquareBorderRadius = true

        view.addSubview(wrapperView)

        self.tabBarTopConstraint = wrapperView.topAnchor.constraint(equalTo: view.bottomAnchor)
        self.tabBarTopConstraint.isActive = false

        wrapperView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let bottomConstraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: wrapperView.bottomAnchor, constant: 20)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        bottomConstraint.isActive = true

        let bottomSafeAreaConstraint = wrapperView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomSafeAreaConstraint.priority = UILayoutPriority(rawValue: 998)
        bottomSafeAreaConstraint.isActive = true

        wrapperView.addSubview(tabBarStackView)
        tabBarStackView.placeEdgeToEdge(in: wrapperView)

        tabBar.items?.enumerated().forEach { index, barButton in
            let button = TabBarButton(index: index)
            button.translatesAutoresizingMaskIntoConstraints = false
            tabBarStackView.addArrangedSubview(button)
            button.setImage(barButton.image, for: .normal)
            button.tintColor = tabBar.unselectedItemTintColor
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.widthAnchor.constraint(equalToConstant: 66).isActive = true
            button.addTarget(self, action: #selector(barButtonDidTap(_:)), for: .touchUpInside)
        }

        tabBarButtons[selectedIndex].tintColor = tabBar.tintColor
    }

    @objc private func barButtonDidTap(_ sender: TabBarButton) {
        guard selectedIndex != sender.index else {
            selectedViewController?.scrollToTop()
            return
        }

        UIView.transition(with: tabBarButtons[selectedIndex],
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.tabBarButtons[self.selectedIndex].isSelected = false },
                          completion: nil)

        UIView.transition(with: sender,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { sender.isSelected = true },
                          completion: nil)

        self.selectedIndex = sender.index
    }
}

public class TabBarButton: UIButton {
    public var index: Int = 0

    public init(index: Int) {
        self.index = index
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tabViewControllers = tabBarController.viewControllers!
        guard let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }

        animateToViewController(at: toIndex)

        return true
    }

    private func animateTabBarLayout() {
        UIView.transition(with: tabBar, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.tabBar.layoutIfNeeded()
        }, completion: nil)
    }

    private func animateToViewController(at index: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedViewController = selectedViewController,
            let fromIndex = tabViewControllers.firstIndex(of: selectedViewController),
            let fromView = selectedViewController.view,
            let toView = tabViewControllers[index].view else {
            return
        }

        guard fromIndex != index else {
            selectedViewController.scrollToTop()
            return
        }

        fromView.superview?.addSubview(toView)

        view.isUserInteractionEnabled = false
        toView.alpha = 0

        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            toView.alpha = 1
        }, completion: { [weak self] _ in
            fromView.removeFromSuperview()
            self?.selectedIndex = index
            self?.view.isUserInteractionEnabled = true
        })
    }
}

public extension UIViewController {
    var mainTabBarViewController: MainTabBarViewController? { tabBarController as? MainTabBarViewController }
}
