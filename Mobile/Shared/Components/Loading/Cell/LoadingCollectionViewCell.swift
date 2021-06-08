//
//  LoadingCollectionViewCell.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class LoadingCollectionViewCell: AppCollectionViewCell {
    @IBOutlet private var loadingComponentView: LoadingComponentView!

    override public class var identifier: Identifierable { R.nib.loadingCollectionViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? LoadingCollectionViewCellDataProvider else { fatalError("error") }

            loadingComponentView.setAndBind(viewModel: dataProvider)
        }
    }
}
