//
//  GameLauncherComponentCell.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class GameLauncherComponentCell: AppCollectionViewCell {
    @IBOutlet private var gameLauncherComponentView: GameLauncherComponentView!

    override public class var identifier: Identifierable { R.nib.gameLauncherComponentCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? GameLauncherComponentCellDataProvider else { fatalError("error") }

            gameLauncherComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
