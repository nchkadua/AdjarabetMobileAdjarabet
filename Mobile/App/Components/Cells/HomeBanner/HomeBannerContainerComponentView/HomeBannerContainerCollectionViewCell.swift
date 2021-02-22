//
//  HomeBannerContainerTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class HomeBannerContainerCollectionViewCell: AppCollectionViewCell {
    @IBOutlet weak private var componentView: HomeBannerContainerComponentView!
    override public class var identifier: Identifierable { R.nib.homeBannerContainerCollectionViewCell.name }  
    
    public override var dataProvider: AppCellDataProvider? {
        didSet {                                      
            guard let dataProvider = dataProvider as? HomeBannerContainerCollectionViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
