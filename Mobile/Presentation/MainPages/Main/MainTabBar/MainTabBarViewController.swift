//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class MainTabBarViewController: UITabBarController {
    public var viewModel: MainTabBarViewModel = DefaultMainTabBarViewModel()
    public lazy var navigator = MainTabBarNavigator(viewController: self)
    private let disposeBag = DisposeBag()

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

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.isHidden = true
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.isHidden = true
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: MainTabBarViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            guard let self = self else {return}
            switch action {
            case .setupTabBar:
                self.setupTabBar()
                self.setupFloatingTabBar()
            case .selectPage(let index):
                self.selectPage(at: index)
            case .scrollSelectedViewControllerToTop:
                self.selectedViewController?.scrollToTop()
            }
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            guard let self = self else {return}
            switch route {
            case .initial:
                self.viewControllers = self.makeViewControllers()
            }
        }).disposed(by: disposeBag)
    }

    // MARK: Floating tab bar methods
    public func hideFloatingTabBar() {
        guard tabBarTopConstraint.isActive != true else {return}
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.tabBarTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }

    public func showFloatingTabBar() {
        guard tabBarTopConstraint.isActive != false else {return}
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.tabBarTopConstraint.isActive = false
            self.view.layoutIfNeeded()
        }, completion: { _ in
        })
    }

    // MARK: Factory methods
    private func makeViewControllers() -> [UIViewController] {
        navigator.makePages()
    }

    // MARK: Basic setup methods
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        delegate = self
    }

    private func setupTabBar() {
        tabBar.tintColor = DesignSystem.Color.primaryText().value
        tabBar.unselectedItemTintColor = DesignSystem.Color.secondaryText().value
        tabBar.barTintColor = .clear
        tabBar.isTranslucent = true
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderColor = nil
        tabBar.layer.borderWidth = 0
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = DesignSystem.Color.primaryBg().value
        tabBar.isHidden = true
    }

    private func setupFloatingTabBar() {
        let wrapperView = AppShadowView()

        wrapperView.shadowColor = DesignSystem.Color.primaryBg().value
        wrapperView.shadowOffset = .init(width: 0, height: 5)
        wrapperView.shadowOpacity = 0.1
        wrapperView.shadowBlur = 5

        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = DesignSystem.Color.thick(alpha: 1).value
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
        tabBarStackView.pin(to: wrapperView)

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

    // MARK: Action methods
    @objc private func barButtonDidTap(_ sender: TabBarButton) {
        viewModel.shouldSelectPage(at: sender.index, currentPageIndex: selectedIndex)
    }

    private func selectPage(at index: Int) {
        UIView.transition(with: tabBarButtons[selectedIndex],
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.tabBarButtons[self.selectedIndex].isSelected = false },
                          completion: nil)

        UIView.transition(with: tabBarButtons[index],
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.tabBarButtons[index].isSelected = true },
                          completion: nil)

        self.selectedIndex = index
    }
}

// MARK: - UITabBarControllerDelegate
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
