//
//  AddressHeaderTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class AddressHeaderTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: AddressHeaderComponentView!
    override public class var identifier: Identifierable { R.nib.addressHeaderTableViewCell.name } // TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? AddressHeaderTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
