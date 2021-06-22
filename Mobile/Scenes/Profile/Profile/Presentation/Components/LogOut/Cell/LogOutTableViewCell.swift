//
//  LogOutTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class LogOutTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: LogOutComponentView!
    override public class var identifier: Identifierable { R.nib.logOutTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? LogOutTableViewCellDataProvider else {
                fatalError("error")
            }
            setBackgorundColor(to: .secondaryBg())
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
