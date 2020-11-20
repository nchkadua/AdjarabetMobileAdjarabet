//
//  TransactionDetailsTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class TransactionDetailsTableViewCell: AppTableViewCell {
    @IBOutlet weak private var transactionDetailsComponentView: TransactionDetailsComponentView!
    override public class var identifier: Identifierable { R.nib.transactionDetailsTableViewCell.name }
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? TransactionDetailsTableViewCellDataProvider else {
                fatalError("error")
            }
            transactionDetailsComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
