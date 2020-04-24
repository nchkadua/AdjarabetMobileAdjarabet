//
//  NotificationsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class NotificationsViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setBaseBackgorundColor()
        setLeftBarButtonItemTitle(to: R.string.localization.notifications_page_title.localized())
    }
}

extension NotificationsViewController: CommonBarButtonProviding { }
