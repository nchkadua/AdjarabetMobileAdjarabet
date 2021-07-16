//
//  DocumentationActionTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class DocumentationActionTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: DocumentationActionComponentView!
    override public class var identifier: Identifierable { R.nib.documentationActionTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? DocumentationActionTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
