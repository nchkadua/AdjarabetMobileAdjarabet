//
//  NotificationTableViewCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class NotificationTableViewCell: AppTableViewCell, EditableCell {
    @IBOutlet weak private var notificationComponentView: NotificationComponentView!

    override public class var identifier: Identifierable { R.nib.notificationTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? NotificationTableViewCellDataProvider else { fatalError("error") }

            notificationComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
