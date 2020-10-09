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

        let color = DesignSystem.Color.separator().value
        navigationBar.titleTextAttributes = [
            .foregroundColor: color,
            .font: DesignSystem.Typography.h4(fontCase: .lower).description.font]
        navigationBar.tintColor = color
    }

    public override var childForStatusBarStyle: UIViewController? { topViewController }

    public override var childForStatusBarHidden: UIViewController? { topViewController }
}
