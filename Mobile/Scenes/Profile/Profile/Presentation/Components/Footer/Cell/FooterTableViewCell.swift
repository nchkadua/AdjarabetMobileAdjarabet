//
//  FooterTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class FooterTableViewCell: AppTableViewCell {
    @IBOutlet weak private var footerComponentView: FooterComponentView!

    override public class var identifier: Identifierable { R.nib.footerTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? FooterTableViewCellDataProvider else { fatalError("error") }

            footerComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
