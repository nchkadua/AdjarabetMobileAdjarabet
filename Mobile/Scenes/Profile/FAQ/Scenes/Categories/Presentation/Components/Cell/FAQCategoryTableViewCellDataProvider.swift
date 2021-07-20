//
//  FAQCategoryTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol FAQCategoryTableViewCellDataProvider: AppCellDelegate, FAQCategoryComponentViewModel, StaticHeightDataProvider { }

public extension FAQCategoryTableViewCellDataProvider {
    var identifier: String { FAQCategoryTableViewCell.identifierValue }
    var height: CGFloat {
        get { 90 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultFAQCategoryComponentViewModel: FAQCategoryTableViewCellDataProvider { }
