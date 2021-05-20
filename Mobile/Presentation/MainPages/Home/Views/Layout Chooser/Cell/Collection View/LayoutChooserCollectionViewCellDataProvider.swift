//
//  LayoutChooserCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol LayoutChooserCollectionViewCellDataProvider: LayoutChooserViewModel, AppCellDataProvider, CellHeighProvidering { }

extension LayoutChooserCollectionViewCellDataProvider {
    var identifier: String { LayoutChooserCollectionViewCell.identifierValue }
}

extension DefaultLayoutChooserViewModel: LayoutChooserCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        .init(width: rect.width, height: 54)
    }
}
