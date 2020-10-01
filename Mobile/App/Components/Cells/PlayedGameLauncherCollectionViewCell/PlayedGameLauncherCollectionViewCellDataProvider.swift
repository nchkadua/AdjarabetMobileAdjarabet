//
//  PlayedGameLauncherCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol PlayedGameLauncherCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, PlayedGameLauncherComponentViewModel, CellHeighProvidering { }

public extension PlayedGameLauncherCollectionViewCellDataProvider {
    var identifier: String { PlayedGameLauncherCollectionViewCell.identifierValue }
}

extension DefaultPlayedGameLauncherComponentViewModel: PlayedGameLauncherCollectionViewCellDataProvider { }

public extension PlayedGameLauncherCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: 120, height: 200)
    }
}
