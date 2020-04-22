//
//  HomeViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class HomeViewController: UIViewController {
    private lazy var floatingTabBarManager = FloatingTabBarManager(viewController: self)

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DesignSystem.Color.neutral800
        setLeftBarButtonItemTitle(to: R.string.localization.home_page_title.localized())
        setupAuthButtonActions()

        setupScrollView()
    }

    private func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.pinSafely(in: view)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 3)

        floatingTabBarManager.observe(scrollView: scrollView)
    }

    private func setupAuthButtonActions() {
        let items = setAuthBarButtonItems()

        items.joinNow.button.addTarget(self, action: #selector(joinNowButtonDidTap), for: .touchUpInside)
        items.login.button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    private func setupProfilButton() {
        setProfileBarButtonItem(text: "₾ 0.00")
    }

    @objc public func joinNowButtonDidTap() {
        print(#function)
        let alert = UIAlertController(title: R.string.localization.join_now.localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc public func loginButtonDidTap() {
        print(#function)
        let alert = UIAlertController(title: R.string.localization.login.localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: CommonBarButtonProviding { }
