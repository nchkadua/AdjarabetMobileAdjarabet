//
//  ABSliderCollectionViewCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/19/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class ABSliderCollectionViewCell: AppCollectionViewCell {
    @IBOutlet private weak var slider: ABSlider!
    override class var identifier: Identifierable { R.nib.abSliderCollectionViewCell.name }

    override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? ABSliderCollectionViewCellDataProvider else {
                fatalError("error")
            }
            slider.viewModel = dataProvider
        }
    }
}
