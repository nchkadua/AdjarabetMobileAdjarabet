//
//  FAQQuestionTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class FAQQuestionTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: FAQQuestionComponentView!
    override public class var identifier: Identifierable { R.nib.faqQuestionTableViewCell.name } // TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? FAQQuestionTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
