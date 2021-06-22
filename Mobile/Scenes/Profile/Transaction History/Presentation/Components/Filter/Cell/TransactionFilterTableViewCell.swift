//
//  TransactionFilterTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class TransactionFilterTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: TransactionFilterComponentView!
    override public class var identifier: Identifierable { R.nib.transactionFilterTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? TransactionFilterTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
