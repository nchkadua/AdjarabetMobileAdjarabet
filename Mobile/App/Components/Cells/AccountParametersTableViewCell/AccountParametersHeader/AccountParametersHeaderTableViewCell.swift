//
//  AccountParametersHeaderTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountParametersHeaderTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: AccountParametersHeaderComponentView!
    override public class var identifier: Identifierable { R.nib.accountParametersHeaderTableViewCell.name } // TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? AccountParametersHeaderTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
