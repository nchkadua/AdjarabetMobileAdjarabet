//
//  TransactionHistoryHeaderCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class TransactionHistoryHeaderCell: AppTableViewCell {
    @IBOutlet weak private var transactionHistoryHeaderView: TransactionHistoryHeaderComponentView!
    override public class var identifier: Identifierable { R.nib.transactionHistoryHeaderCell.name }
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? TransactionHistoryHeaderCellDataProvider else { fatalError("error") }
            transactionHistoryHeaderView.setAndBind(viewModel: dataProvider)
        }
    }
}
