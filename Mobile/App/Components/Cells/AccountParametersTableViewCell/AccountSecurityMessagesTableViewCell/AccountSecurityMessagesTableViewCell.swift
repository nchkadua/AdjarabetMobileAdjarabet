//
//  AccountSecurityMessagesTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountSecurityMessagesTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: AccountSecurityMessagesComponentView!
    override public class var identifier: Identifierable { R.nib.accountSecurityMessagesTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? AccountSecurityMessagesTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
