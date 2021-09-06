//
//  StatusMessageTableViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class StatusMessageTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: StatusMessageComponentView!
//    override public class var identifier: Identifierable { R.nib.StatusMessageTableViewCell.name } //TODO 
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? StatusMessageTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
