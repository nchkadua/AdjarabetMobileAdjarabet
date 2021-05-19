//
//  ABSliderCell.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class ABSliderCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!

    func configure(with model: ABSliderCellModel) {
        imageView.image = model.image
    }
}
