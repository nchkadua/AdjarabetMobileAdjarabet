//
//  GameLauncherCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol GameLauncherCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, GameLauncherComponentViewModel, CellHeighProvidering { }

public extension GameLauncherCollectionViewCellDataProvider {
    var identifier: String { GameLauncherCollectionViewCell.identifierValue }
}

extension DefaultGameLauncherComponentViewModel: GameLauncherCollectionViewCellDataProvider { }

public extension GameLauncherCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width, height: 94)
    }
}

public extension GameLauncherCollectionViewCellDataProvider {
    func didSelect(at indexPath: IndexPath) {
        action.onNext(.didSelect(self, indexPath: indexPath))
    }
}
