//
//  ActiveMyBonusItemCollectionViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class ActiveMyBonusItemCollectionViewCell: AppCollectionViewCell {
	@IBOutlet private var componentView: ActiveMyBonusItemComponentView!

	override public class var identifier: Identifierable {
		R.nib.activeMyBonusItemCollectionViewCell.name
	}

	public override var dataProvider: AppCellDataProvider? {
		didSet {
			guard let dataProvider = dataProvider as? ActiveMyBonusItemCollectionViewCellDataProvider else { fatalError("error") }

			componentView.setAndBind(viewModel: dataProvider)
		}
	}
}
