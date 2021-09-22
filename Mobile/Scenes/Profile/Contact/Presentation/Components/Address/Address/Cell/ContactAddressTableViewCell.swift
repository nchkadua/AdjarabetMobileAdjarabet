//
//  ContactAddressTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class ContactAddressTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: ContactAddressComponentView!
    override public class var identifier: Identifierable { R.nib.contactAddressTableViewCell.name } // TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? ContactAddressTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
