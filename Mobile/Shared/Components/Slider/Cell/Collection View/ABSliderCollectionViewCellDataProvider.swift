//
//  ABSliderCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/19/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol ABSliderCollectionViewCellDataProvider: ABSliderViewModel, AppCellDataProvider, CellHeighProvidering { }

extension ABSliderCollectionViewCellDataProvider {
    var identifier: String { ABSliderCollectionViewCell.identifierValue }
}

extension DefaultABSliderViewModel: ABSliderCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        .init(width: rect.width, height: 360)
    }
}
