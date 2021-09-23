//
//  BlockedUserNotificationTableViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 23.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class BlockedUserNotificationTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: BlockedUserNotificationComponentView!
//    override public class var identifier: Identifierable { R.nib.BlockedUserNotificationTableViewCell.name } //TODO 

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? BlockedUserNotificationTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
