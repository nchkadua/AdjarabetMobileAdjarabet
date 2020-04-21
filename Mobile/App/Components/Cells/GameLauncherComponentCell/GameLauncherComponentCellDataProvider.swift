//
//  GameLauncherComponentCellDataProvider.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol GameLauncherComponentCellDataProvider: AppCellDataProvider, AppCellDelegate, GameLauncherComponentViewModel, CellHeighProvidering { }

public extension GameLauncherComponentCellDataProvider {
    var identifier: String { GameLauncherComponentCell.identifierValue }
}

extension DefaultGameLauncherComponentViewModel: GameLauncherComponentCellDataProvider { }

public extension GameLauncherComponentCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width, height: 94)
    }
}

public extension GameLauncherComponentCellDataProvider {
    func didSelect(at indexPath: IndexPath) {
        action.onNext(.didSelect(self, indexPath: indexPath))
    }
}
