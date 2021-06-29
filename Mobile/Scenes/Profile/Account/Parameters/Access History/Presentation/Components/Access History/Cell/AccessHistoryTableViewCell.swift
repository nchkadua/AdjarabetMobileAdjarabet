//
//  AccessHistoryTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccessHistoryTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: AccessHistoryComponentView!
    override public class var identifier: Identifierable { R.nib.accessHistoryTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? AccessHistoryTableViewCellDataProvider else {
                fatalError("error")
            }
            setBackgorundColor(to: .secondaryBg())
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
