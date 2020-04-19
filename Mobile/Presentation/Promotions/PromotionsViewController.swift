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

        view.setBackgorundColor(to: .neutral800)
        setLeftBarButtonItemTitle(to: R.string.localization.promotions_page_title.localized())
    }
}

extension PromotionsViewController: CommonBarButtonProviding { }
