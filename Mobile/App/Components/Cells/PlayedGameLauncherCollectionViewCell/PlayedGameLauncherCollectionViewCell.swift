//
//  PlayedGameLauncherCollectionViewCell.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class PlayedGameLauncherCollectionViewCell: AppCollectionViewCell {
    @IBOutlet private var playedGameLauncherComponentView: PlayedGameLauncherComponentView!

    override public class var identifier: Identifierable { R.nib.playedGameLauncherCollectionViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? PlayedGameLauncherCollectionViewCellDataProvider else { fatalError("error") }

            playedGameLauncherComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
