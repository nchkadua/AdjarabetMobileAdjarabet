//
//  HomeViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class HomeViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DesignSystem.Color.neutral800
        setLeftBarButtonItemTitle(to: "Games")
        bindToAuthButtonActions()
        setProfileBarButtonItem(text: "₾ 240.56")
    }

    private func bindToAuthButtonActions() {
        let items = setAuthBarButtonItems()

        items.joinNow.button.addTarget(self, action: #selector(joinNowButtonDidTap), for: .touchUpInside)
        items.login.button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    @objc public func joinNowButtonDidTap() {
        print(#function)
        let alert = UIAlertController(title: "Join Now", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc public func loginButtonDidTap() {
        print(#function)
        let alert = UIAlertController(title: "Login", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: CommontBarButtonProviding { }
