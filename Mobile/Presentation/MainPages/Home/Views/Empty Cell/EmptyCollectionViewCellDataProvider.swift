//
//  EmptyCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

protocol EmptyCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, CellHeighProvidering { }

extension EmptyCollectionViewCellDataProvider {
    var identifier: String { EmptyCollectionViewCell.identifierValue }
}

extension EmptyCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        .init(width: rect.width, height: 105)
    }
}

class DefaultEmptyCollectionViewCellDataProvider: EmptyCollectionViewCellDataProvider {
    func didSelect(at indexPath: IndexPath) { }
}
