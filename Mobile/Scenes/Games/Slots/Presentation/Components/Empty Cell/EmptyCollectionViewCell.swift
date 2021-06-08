//
//  EmptyCollectionViewCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class EmptyCollectionViewCell: AppCollectionViewCell {
    override class var identifier: Identifierable { R.nib.emptyCollectionViewCell.name }
    override var dataProvider: AppCellDataProvider? { didSet { } }
}
