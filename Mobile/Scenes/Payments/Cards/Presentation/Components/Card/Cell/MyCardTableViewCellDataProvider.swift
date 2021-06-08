//
//  MyCardTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol MyCardTableViewCellDataProvider: AppDeletableCellDelegate,
                                                 MyCardComponentViewModel,
                                                 StaticHeightDataProvider { }

public extension MyCardTableViewCellDataProvider {
    var identifier: String { MyCardTableViewCell.identifierValue }
    var height: CGFloat {
        get { 180 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultMyCardComponentViewModel: MyCardTableViewCellDataProvider { }
