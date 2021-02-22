//
//  HomeBannerTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class HomeBannerCollectionViewCell: AppCollectionViewCell {
    @IBOutlet weak private var componentView: HomeBannerComponentView!
    override public class var identifier: Identifierable { R.nib.homeBannerCollectionViewCell.name }  
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? HomeBannerCollectionViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
