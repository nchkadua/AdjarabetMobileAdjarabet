//
//  EndedMyBonusesHeaderCollectionViewCell.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 01.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class EndedMyBonusesHeaderCollectionViewCell: AppCollectionViewCell {
	@IBOutlet private var componentView: EndedMyBonusesHeaderComponentView!

	override public class var identifier: Identifierable {
		R.nib.endedMyBonusesHeaderCollectionViewCell.name
	}

	public override var dataProvider: AppCellDataProvider? {
		didSet {
			guard let dataProvider = dataProvider as? EndedMyBonusesHeaderCollectionViewCellDataProvider else { fatalError("error") }

			componentView.setAndBind(viewModel: dataProvider)
		}
	}
}
