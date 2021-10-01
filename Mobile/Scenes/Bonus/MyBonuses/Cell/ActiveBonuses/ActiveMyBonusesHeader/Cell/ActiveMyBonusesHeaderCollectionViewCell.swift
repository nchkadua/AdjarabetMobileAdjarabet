//
//  ActiveMyBonusesHeaderCollectionViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class ActiveMyBonusesHeaderCollectionViewCell: AppCollectionViewCell {
	@IBOutlet private var componentView: ActiveMyBonusesHeaderComponentView!

	override public class var identifier: Identifierable {
		R.nib.activeMyBonusesHeaderCollectionViewCell.name // TODO
	}

	public override var dataProvider: AppCellDataProvider? {
		didSet {
			guard let dataProvider = dataProvider as? ActiveMyBonusesHeaderCollectionViewCellDataProvider else { fatalError("error") }

			componentView.setAndBind(viewModel: dataProvider)
		}
	}
}
