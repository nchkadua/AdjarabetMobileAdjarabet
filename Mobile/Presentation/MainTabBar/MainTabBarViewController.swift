//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class MainTabBarViewController: UITabBarController {
    public var animationDuration: TimeInterval { 0.3 }
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

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        delegate = self
        hidesBottomBarWhenPushed = true
        setupTabBar()

        viewControllers = makeViewControllers()
        setupFloatingTabBar()
    }

    func hideHeader() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.tabBarTopConstraint.isActive = true
            self.view.layoutIfNeeded()
        })
    }

    func showHeader() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
            self.tabBarTopConstraint.isActive = false
            self.view.layoutIfNeeded()
        })
    }

    private func makeViewControllers() -> [UIViewController] {
        let v1 = R.storyboard.mainTabBar().instantiate(controller: EmptyViewController.self)!
        let v2 = R.storyboard.mainTabBar().instantiate(controller: EmptyViewController.self)!
        let v3 = R.storyboard.mainTabBar().instantiate(controller: EmptyViewController.self)!
        let v4 = R.storyboard.mainTabBar().instantiate(controller: EmptyViewController.self)!
        let v5 = R.storyboard.mainTabBar().instantiate(controller: EmptyViewController.self)!

        v1.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.home(), selectedImage: R.image.tabBar.homeSelected())
        v2.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.discover(), selectedImage: R.image.tabBar.discoverSelected())
        v3.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.addProduct(), selectedImage: R.image.tabBar.addProduct())
        v4.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.chat(), selectedImage: R.image.tabBar.chatSelected())
        v5.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.settgins(), selectedImage: R.image.tabBar.settingsSelected())

        v1.view.backgroundColor = .red
        v2.view.backgroundColor = .yellow
        v3.view.backgroundColor = .black
        v4.view.backgroundColor = .blue
        v5.view.backgroundColor = .purple

        v1.title = "Page 1"
        v2.title = "Page 2"
        v3.title = "Notifications"
        v4.title = "Page 4"
        v5.title = "Page 5"

        return [v1, v2, v3, v4, v5].map { $0.wrap(in: AppNavigationController.self) }
    }

    private func setupTabBar() {
        tabBar.tintColor = R.color.tabBar.tintColor()
        tabBar.unselectedItemTintColor = R.color.tabBar.unselectedItemTintColor()
        tabBar.barTintColor = .clear
        tabBar.isTranslucent = true
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderColor = nil
        tabBar.layer.borderWidth = 0
        tabBar.backgroundColor = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isHidden = true
    }

    private func setupFloatingTabBar() {
        let wrapperView = AppCircularView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = .white
        wrapperView.hasSquareBorderRadius = true

        view.addSubview(wrapperView)

        self.tabBarTopConstraint = wrapperView.topAnchor.constraint(equalTo: view.bottomAnchor)
        self.tabBarTopConstraint.isActive = false

        wrapperView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let bottomConstraint = wrapperView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        bottomConstraint.isActive = true

        wrapperView.addSubview(tabBarStackView)
        tabBarStackView.placeEdgeToEdge(in: wrapperView)

        tabBar.items?.enumerated().forEach { index, barButton in
            let button = TabBarButton(index: index)
            button.translatesAutoresizingMaskIntoConstraints = false
            tabBarStackView.addArrangedSubview(button)
            button.setImage(barButton.image, for: .normal)
            button.setImage(barButton.selectedImage, for: .selected)
            button.tintColor = tabBar.tintColor
            button.setTitleColor(tabBar.tintColor, for: .selected)
            button.setTitleColor(tabBar.unselectedItemTintColor, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 56).isActive = true
            button.widthAnchor.constraint(equalToConstant: 60).isActive = true
            button.addTarget(self, action: #selector(barButtonDidTap(_:)), for: .touchUpInside)
        }

        tabBarButtons[0].isSelected = true
    }

    @objc private func barButtonDidTap(_ sender: TabBarButton) {
        guard selectedIndex != sender.index else {return}

//        tabBarButtons[selectedIndex].isSelected = false
//        sender.isSelected = true

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

//        if tabBarController(self, shouldSelect: viewControllers![sender.index]) {
//
//        }
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
//        if let controllers = tabBarController.viewControllers, let index = controllers.firstIndex(of: viewController), index == 2 {
//            let vc = R.storyboard.photoCapture().instantiate(controller: PhotoCaptureViewController.self)!
//            vc.mode = .photoGallery(hasCloseButton: true)
//            vc.modalPresentationStyle = .fullScreen
//            vc.hidesBottomBarWhenPushed = true
//            present(vc, animated: true, completion: nil)
//            return false
//        }

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

//        selectedIndex = index
//        view.layoutIfNeeded()
//        selectedIndex = fromIndex
//        view.layoutIfNeeded()
//
//        let vc = R.storyboard.main().instantiate(controller: EmptyViewController.self)!
//        vc.view.backgroundColor = .red
//        vc.title = "awdawdawd"
//        let nav = vc.wrap(in: AppNavigationController.self)
//
//        nav.view.translatesAutoresizingMaskIntoConstraints = false
//        fromView.superview?.addSubview(nav.view)
//        nav.view.placeEdgeToEdge(in: fromView.superview!)

//        print(tabViewControllers[index].parent?.className)
//        view.addSubview(toView)

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

//extension UITabBar {
//    override open var traitCollection: UITraitCollection {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return UITraitCollection(horizontalSizeClass: .compact)
//        }
//
//        return super.traitCollection
//    }
//}

public extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }

            switch view {
            case let scrollView as UIScrollView where scrollView.scrollsToTop:
                let point = CGPoint(x: 0, y: -(view.safeAreaInsets.top + scrollView.contentInset.top))
                scrollView.setContentOffset(point, animated: true)
                return
            default:
                break
            }

            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }

        scrollToTop(view: view)
    }
}

public extension UIView {
    var snapshot: UIImage {
        UIGraphicsImageRenderer(bounds: bounds).image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    @discardableResult
    func placeEdgeToEdge(in parentView: UIView) -> EdgeConstraint {
        let top = topAnchor.constraint(equalTo: parentView.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        let left = leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        let right = trailingAnchor.constraint(equalTo: parentView.trailingAnchor)

        NSLayoutConstraint.activate([top, bottom, left, right])

        return EdgeConstraint(top: top, bottom: bottom, leading: left, traling: right)
    }

    @discardableResult
    func pinSafely(in parentView: UIView) -> EdgeConstraint {
        let top = topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
        let left = leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor)
        let right = trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor)

        NSLayoutConstraint.activate([top, bottom, left, right])

        return EdgeConstraint(top: top, bottom: bottom, leading: left, traling: right)
    }

    func removeAllSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

public struct EdgeConstraint {
    public let top: NSLayoutConstraint
    public let bottom: NSLayoutConstraint
    public let leading: NSLayoutConstraint
    public let traling: NSLayoutConstraint
}

//func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//
//    // Creating the 'to' and 'from' views for the transition
//    let fromView = tabBarController.selectedViewController!.view
//    let toView = viewController.view
//
//    if fromView == toView {
//        // If views are the same, then don't do a transition
//        return false
//    }
//
//    self.view.userInteractionEnabled = false
//
//    if let window = fromView.window {
//        let overlayView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
//        viewController.view.addSubview(overlayView)
//        UIView.transitionFromView(fromView, toView: toView, duration: 2.0, options: .TransitionCrossDissolve, completion: { (finish) in
//            window.rootViewController = viewController
//            UIView.animateWithDuration(0.4, delay: 0.0, options: .TransitionCrossDissolve, animations: {
//                overlayView.alpha = 0
//                }, completion: { (finish) in
//                    overlayView.removeFromSuperview()
//                })
//            })
//        }
//
//        self.view.userInteractionEnabled = true
//
//        return true
//    }
//}
