//
//  EndedMyBonusesHeaderCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol EndedMyBonusesHeaderCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, EndedMyBonusesHeaderComponentViewModel, CellHeighProvidering { }

public extension EndedMyBonusesHeaderCollectionViewCellDataProvider {
	var identifier: String { EndedMyBonusesHeaderCollectionViewCell.identifierValue }
}

extension DefaultEndedMyBonusesHeaderComponentViewModel: EndedMyBonusesHeaderCollectionViewCellDataProvider { }

public extension EndedMyBonusesHeaderCollectionViewCellDataProvider {
	func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
		CGSize(width: UIScreen.main.bounds.width - 30, height: 32 + 12)
	}
}
