//
//  LayoutChooserCollectionViewCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class LayoutChooserCollectionViewCell: AppCollectionViewCell {
    @IBOutlet private weak var view: LayoutChooserView!
    override class var identifier: Identifierable { R.nib.layoutChooserCollectionViewCell.name }

    override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? LayoutChooserCollectionViewCellDataProvider else {
                fatalError("error")
            }
            view.viewModel = dataProvider
        }
    }
}
