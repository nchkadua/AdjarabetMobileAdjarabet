//
//  QuickActionsHeaderCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class QuickActionsHeaderCell: AppTableViewCell {
    @IBOutlet weak private var quickActionsHeaderView: QuickActionsHeaderView!

    override public class var identifier: Identifierable { R.nib.quickActionsHeaderCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? QuickActionsHeaderCellDataProvider else { fatalError("error") }

            quickActionsHeaderView.setAndBind(viewModel: dataProvider)
        }
    }
}
