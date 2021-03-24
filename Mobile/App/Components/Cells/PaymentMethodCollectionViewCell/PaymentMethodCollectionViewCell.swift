//
//  PaymentMethodCollectionViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class PaymentMethodCollectionViewCell: AppCollectionViewCell {
    @IBOutlet weak private var componentView: PaymentMethodComponentView!

    override public class var identifier: Identifierable { R.nib.paymentMethodCollectionViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? PaymentMethodCollectionViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
