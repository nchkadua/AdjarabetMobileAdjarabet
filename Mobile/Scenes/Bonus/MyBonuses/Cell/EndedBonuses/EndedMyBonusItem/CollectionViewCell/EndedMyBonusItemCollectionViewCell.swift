//
//  EndedMyBonusItemCollectionViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class EndedMyBonusItemCollectionViewCell: AppCollectionViewCell {
	@IBOutlet private var componentView: EndedMyBonusItemComponentView!

	override public class var identifier: Identifierable {
		R.nib.endedMyBonusItemCollectionViewCell.name
	}

	public override var dataProvider: AppCellDataProvider? {
		didSet {
			guard let dataProvider = dataProvider as? EndedMyBonusItemCollectionViewCellDataProvider else { fatalError("error") }

			componentView.setAndBind(viewModel: dataProvider)
		}
	}
}
