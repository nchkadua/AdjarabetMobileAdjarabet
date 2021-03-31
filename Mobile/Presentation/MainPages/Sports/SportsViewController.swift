//
//  SportViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class SportsViewController: ABViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMainContainerSwipeEnabled(false)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        makeAdjarabetLogo()
        navigationItem.rightBarButtonItem = makeBalanceBarButtonItem().barButtonItem
    }
}

extension SportsViewController: CommonBarButtonProviding { }
