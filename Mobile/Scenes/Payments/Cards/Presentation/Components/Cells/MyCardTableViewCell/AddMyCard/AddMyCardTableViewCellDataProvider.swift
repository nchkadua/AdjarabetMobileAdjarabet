//
//  AddMyCardTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol AddMyCardTableViewCellDataProvider: AddMyCardComponentViewModel,
                                                    StaticHeightDataProvider { }

public extension AddMyCardTableViewCellDataProvider {
    var identifier: String { AddMyCardTableViewCell.identifierValue }
    var height: CGFloat {
        get { 80 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultAddMyCardComponentViewModel: AddMyCardTableViewCellDataProvider { }
