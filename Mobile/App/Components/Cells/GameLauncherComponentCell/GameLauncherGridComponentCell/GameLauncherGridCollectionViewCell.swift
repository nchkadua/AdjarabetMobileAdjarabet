//
//  GameLauncherGridCollectionViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class GameLauncherGridCollectionViewCell: AppCollectionViewCell {
    @IBOutlet weak private var componentView: GameLauncherGridComponentView!
    override public class var identifier: Identifierable { R.nib.gameLauncherGridCollectionViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? GameLauncherGridCollectionViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
