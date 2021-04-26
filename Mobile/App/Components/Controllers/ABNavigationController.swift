//
//  AppNavigationController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ABNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
        delegate = self

        setupDefaultSettings()
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        viewControllers.count > 1
    }

    private func setupDefaultSettings() {
        navigationBar.styleForPrimaryPage()
        view.backgroundColor = .clear

        let color = DesignSystem.Color.secondaryText().value
        navigationBar.titleTextAttributes = [
            .foregroundColor: color,
            .font: DesignSystem.Typography.subHeadline(fontCase: .lower).description.font]
        navigationBar.tintColor = color
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is PageViewControllerProtocol {
            mainContainerViewController?.setPageViewControllerSwipeEnabled(true)
        } else {
            mainContainerViewController?.setPageViewControllerSwipeEnabled(false)
        }
    }

    public override var childForStatusBarStyle: UIViewController? { topViewController }

    public override var childForStatusBarHidden: UIViewController? { topViewController }
}
