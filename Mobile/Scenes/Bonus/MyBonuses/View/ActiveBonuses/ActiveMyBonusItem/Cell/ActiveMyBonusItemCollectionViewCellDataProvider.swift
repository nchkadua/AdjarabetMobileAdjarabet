//
//  ActiveMyBonusItemCollectionViewDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol ActiveMyBonusItemCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, ActiveMyBonusItemComponentViewModel, CellHeighProvidering { }

public extension ActiveMyBonusItemCollectionViewCellDataProvider {
	var identifier: String { ActiveMyBonusItemCollectionViewCell.identifierValue }
}

extension DefaultActiveMyBonusItemComponentViewModel: ActiveMyBonusItemCollectionViewCellDataProvider {
	public func didSelect(at indexPath: IndexPath) {
	}
}

public extension ActiveMyBonusItemCollectionViewCellDataProvider {
	func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
		.init(width: (UIScreen.main.bounds.width - 15 - 15 - 8) / 2, height: 185)
	}
}
