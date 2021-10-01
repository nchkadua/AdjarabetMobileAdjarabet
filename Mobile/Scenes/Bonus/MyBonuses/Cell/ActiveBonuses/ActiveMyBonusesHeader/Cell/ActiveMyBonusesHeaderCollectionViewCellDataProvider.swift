//
//  ActiveMyBonusesHeaderCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol ActiveMyBonusesHeaderCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, ActiveMyBonusesHeaderComponentViewModel, CellHeighProvidering { }

public extension ActiveMyBonusesHeaderCollectionViewCellDataProvider {
	var identifier: String { ActiveMyBonusesHeaderCollectionViewCell.identifierValue }
}

extension DefaultActiveMyBonusesHeaderComponentViewModel: ActiveMyBonusesHeaderCollectionViewCellDataProvider {
	public func didSelect(at indexPath: IndexPath) {
	}
}

public extension ActiveMyBonusesHeaderCollectionViewCellDataProvider {
	func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
		CGSize(width: UIScreen.main.bounds.width - 15 - 15, height: 30 + 8)
	}
}
