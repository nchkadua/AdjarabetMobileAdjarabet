//
//  TitleDescriptionButtonTableViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class TitleDescriptionButtonTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: TitleDescriptionButtonComponentView!
//    override public class var identifier: Identifierable { R.nib.TitleDescriptionButtonTableViewCell.name } //TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? TitleDescriptionButtonTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
