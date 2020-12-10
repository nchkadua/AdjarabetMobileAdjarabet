//
//  SecurityLevelTypeTableViewCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class SecurityLevelTypeTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: SecurityLevelTypeComponentView!
    override public class var identifier: Identifierable { R.nib.securityLevelTypeTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? SecurityLevelTypeTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
