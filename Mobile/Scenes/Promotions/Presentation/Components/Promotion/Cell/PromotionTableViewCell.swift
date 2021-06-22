//
//  PromotionTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class PromotionTableViewCell: AppTableViewCell {
    @IBOutlet weak private var promotionComponentView: PromotionComponentView!

    override public class var identifier: Identifierable { R.nib.promotionTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? PromotionTableViewCellDataProvider else { fatalError("error") }

            promotionComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
