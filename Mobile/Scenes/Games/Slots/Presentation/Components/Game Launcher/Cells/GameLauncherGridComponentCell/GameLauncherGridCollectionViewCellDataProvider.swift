//
//  GameLauncherGridCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol GameLauncherGridCollectionViewCellDataProvider: GameLauncherGridComponentViewModel,
                                                                AppCellDataProvider,
                                                                AppCellDelegate,
                                                                CellHeighProvidering { }

public extension GameLauncherGridCollectionViewCellDataProvider {
    var identifier: String { GameLauncherGridCollectionViewCell.identifierValue }
}

extension DefaultGameLauncherGridComponentViewModel: GameLauncherGridCollectionViewCellDataProvider {}

public extension GameLauncherGridCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width / 2, height: rect.height / 5.5)
    }
}
