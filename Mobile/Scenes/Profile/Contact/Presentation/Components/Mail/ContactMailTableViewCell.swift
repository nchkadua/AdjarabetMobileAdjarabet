//
//  ContactMailTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class ContactMailTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: ContactMailComponentView!
    override public class var identifier: Identifierable { R.nib.contactMailTableViewCell.name } //TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? ContactMailTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
