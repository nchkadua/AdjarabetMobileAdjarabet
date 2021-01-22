//
//  MyCardTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class MyCardTableViewCell: AppTableViewCell, EditableCell {
    @IBOutlet weak private var componentView: MyCardComponentView!
    override public class var identifier: Identifierable { R.nib.myCardTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? MyCardTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
