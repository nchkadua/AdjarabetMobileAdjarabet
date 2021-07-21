//
//  CloseAccountButtonTableViewCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class CloseAccountButtonTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: CloseAccountButtonComponentView!
    override public class var identifier: Identifierable { R.nib.closeAccountButtonTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? CloseAccountButtonTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
