//
//  RecentlyPlayedCollectionViewCell.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class RecentlyPlayedCollectionViewCell: AppCollectionViewCell {
    @IBOutlet private var recentlyPlayedComponentView: RecentlyPlayedComponentView!

    override public class var identifier: Identifierable { R.nib.recentlyPlayedCollectionViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? RecentlyPlayedCollectionViewCellDataProvider else { fatalError("error") }

            recentlyPlayedComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
