//
//  SportViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class SportsViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setBaseBackgorundColor()
        makeLeftBarButtonItemTitle(to: R.string.localization.sports_page_title.localized())
    }
}

extension SportsViewController: CommonBarButtonProviding { }
