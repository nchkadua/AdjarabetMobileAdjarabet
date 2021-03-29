//
//  SuggestedAmountCollectionViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/29/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class SuggestedAmountCollectionViewCell: AppCollectionViewCell {
    @IBOutlet weak private var componentView: SuggestedAmountComponentView!

    override public class var identifier: Identifierable { R.nib.suggestedAmountCollectionViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? SuggestedAmountCollectionViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
