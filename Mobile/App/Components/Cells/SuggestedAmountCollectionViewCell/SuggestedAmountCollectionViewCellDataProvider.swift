//
//  SuggestedAmountCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/29/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol SuggestedAmountCollectionViewCellDataProvider: SuggestedAmountComponentViewModel, AppCellDataProvider, CellHeighProvidering { }

public extension SuggestedAmountCollectionViewCellDataProvider {
    var identifier: String { SuggestedAmountCollectionViewCell.identifierValue }
}

extension DefaultSuggestedAmountComponentViewModel: SuggestedAmountCollectionViewCellDataProvider { }

public extension SuggestedAmountCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: 75, height: 40)
    }
}
