//
//  SecurityLevelTableViewCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class SecurityLevelTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: SecurityLevelComponentView!
    override public class var identifier: Identifierable { R.nib.securityLevelTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? SecurityLevelTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
