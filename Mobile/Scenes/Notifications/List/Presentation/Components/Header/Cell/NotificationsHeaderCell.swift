//
//  NotificationsHeaderCell.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class NotificationsHeaderCell: AppTableViewCell {
    @IBOutlet weak private var notificationsHeaderView: NotificationsHeaderComponentView!

    override public class var identifier: Identifierable { R.nib.notificationsHeaderCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? NotificationsHeaderCellDataProvider else { fatalError("error") }

            notificationsHeaderView.setAndBind(viewModel: dataProvider)
        }
    }
}
