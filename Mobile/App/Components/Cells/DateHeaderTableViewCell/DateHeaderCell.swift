//
//  DateHeaderCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DateHeaderCell: AppTableViewCell {
    @IBOutlet weak private var dateHeaderView: DateHeaderComponentView!
    override public class var identifier: Identifierable { R.nib.dateHeaderCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? DateHeaderCellDataProvider else { fatalError("error") }
            dateHeaderView.setAndBind(viewModel: dataProvider)
        }
    }
}
