//
//  BalanceTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class BalanceTableViewCell: AppTableViewCell {
    @IBOutlet weak private var balanceComponentView: BalanceComponentView!

    override public class var identifier: Identifierable { R.nib.balanceTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? BalanceTableViewCellDataProvider else { fatalError("error") }

            balanceComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
