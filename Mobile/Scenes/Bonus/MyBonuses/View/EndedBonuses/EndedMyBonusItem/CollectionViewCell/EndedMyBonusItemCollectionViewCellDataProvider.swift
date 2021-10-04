//
//  EndedMyBonusItemCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol EndedMyBonusItemCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, EndedMyBonusItemComponentViewModel, CellHeighProvidering { }

public extension EndedMyBonusItemCollectionViewCellDataProvider {
	var identifier: String { EndedMyBonusItemCollectionViewCell.identifierValue }
}

extension DefaultEndedMyBonusItemComponentViewModel: EndedMyBonusItemCollectionViewCellDataProvider {
	public func didSelect(at indexPath: IndexPath) {
	}
}

public extension EndedMyBonusItemCollectionViewCellDataProvider {
	func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
		CGSize(width: UIScreen.main.bounds.width - 15 * 2, height: 34 + 18 + 10)
	}
}
