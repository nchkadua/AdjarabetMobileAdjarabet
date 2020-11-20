//
//  TransactionHistoryTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class TransactionHistoryTableViewCell: AppTableViewCell {
    @IBOutlet weak private var transactionHistoryComponentView: TransactionHistoryComponentView!
    override public class var identifier: Identifierable { R.nib.transactionHistoryTableViewCell.name }
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? TransactionHistoryTableViewCellDataProvider else {
                fatalError("error")
            }
            transactionHistoryComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
