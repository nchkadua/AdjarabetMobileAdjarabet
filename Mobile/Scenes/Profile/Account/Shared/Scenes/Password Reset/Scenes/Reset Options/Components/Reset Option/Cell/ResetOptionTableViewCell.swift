//
//  ResetOptionTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class ResetOptionTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: ResetOptionComponentView!
    override public class var identifier: Identifierable { R.nib.resetOptionTableViewCell.name } // TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? ResetOptionTableViewCellDataProvider else {
                fatalError("error")
            }

            setBackgorundColor(to: .secondaryBg())
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
