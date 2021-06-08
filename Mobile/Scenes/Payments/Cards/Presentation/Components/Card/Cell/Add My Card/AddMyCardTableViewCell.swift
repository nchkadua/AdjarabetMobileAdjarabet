//
//  AddMyCardTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class AddMyCardTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: AddMyCardComponentView!
    override public class var identifier: Identifierable { R.nib.addMyCardTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? AddMyCardTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
