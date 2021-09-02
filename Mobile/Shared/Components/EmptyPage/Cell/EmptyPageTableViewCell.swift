//
//  EmptyPageTableViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class EmptyPageTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: EmptyStateComponentView!
//    override public class var identifier: Identifierable { R.nib.EmptyPageTableViewCell.name } //TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? EmptyPageTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
