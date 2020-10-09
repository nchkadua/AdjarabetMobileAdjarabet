//
//  ProfileInfoTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ProfileInfoTableViewCell: AppTableViewCell {
    @IBOutlet weak private var profileInfoComponentView: ProfileInfoComponentView!

    override public class var identifier: Identifierable { R.nib.profileInfoTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? ProfileInfoTableViewCellDataProvider else { fatalError("error") }

            profileInfoComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
