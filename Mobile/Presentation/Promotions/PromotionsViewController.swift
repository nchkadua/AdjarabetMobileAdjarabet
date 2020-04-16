//
//  PromotionsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class PromotionsViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DesignSystem.Color.neutral800
        setLeftBarButtonItemTitle(to: "Promotions")
    }
}

extension PromotionsViewController: CommonBarButtonProviding { }
