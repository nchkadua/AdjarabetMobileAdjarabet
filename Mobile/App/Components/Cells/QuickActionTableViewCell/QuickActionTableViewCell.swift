//
//  QuickActionTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class QuickActionTableViewCell: AppTableViewCell {
    @IBOutlet weak private var quickActionComponentView: QuickActionComponentView!

    override public class var identifier: Identifierable { R.nib.quickActionTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? QuickActionTableViewCellDataProvider else { fatalError("error") }

            quickActionComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
