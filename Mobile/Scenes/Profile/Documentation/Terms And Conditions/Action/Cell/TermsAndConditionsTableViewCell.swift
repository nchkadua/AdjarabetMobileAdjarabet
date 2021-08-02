//
//  TermsAndConditionsTableViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 02.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class TermsAndConditionsTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: TermsAndConditionsComponentView!
    override public class var identifier: Identifierable { R.nib.termsAndConditionsTableViewCell.name }
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? TermsAndConditionsTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
