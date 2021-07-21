//
//  FAQCategoryTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class FAQCategoryTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: FAQCategoryComponentView!
    override public class var identifier: Identifierable { R.nib.faqCategoryTableViewCell.name } //TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? FAQCategoryTableViewCellDataProvider else {
                fatalError("error")
            }
            setBackgorundColor(to: .secondaryBg())
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
