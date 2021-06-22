//
//  VideoCardTableViewCell.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class VideoCardTableViewCell: AppTableViewCell {
    @IBOutlet weak private var componentView: VideoCardComponentView!
    override public class var identifier: Identifierable { R.nib.videoCardTableViewCell.name }

    public override var dataProvider: AppCellDataProvider? {
        didSet {
            guard let dataProvider = dataProvider as? VideoCardTableViewCellDataProvider else {
                fatalError("error")
            }
            componentView.setAndBind(viewModel: dataProvider)
        }
    }
}
