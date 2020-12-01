//
//  AccountParametersTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountParametersTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: AccountParametersComponentView!
    override public class var identifier: Identifierable { R.nib.accountParametersTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? AccountParametersTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
