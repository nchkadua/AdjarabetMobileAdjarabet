//
//  ContactPhoneTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class ContactPhoneTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: ContactPhoneComponentView!
    override public class var identifier: Identifierable { R.nib.contactPhoneTableViewCell.name } //TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? ContactPhoneTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
