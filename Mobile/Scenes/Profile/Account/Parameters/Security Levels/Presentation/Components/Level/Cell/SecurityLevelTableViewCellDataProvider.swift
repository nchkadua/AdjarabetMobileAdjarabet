//
//  SecurityLevelTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol SecurityLevelTableViewCellDataProvider: SecurityLevelComponentViewModel, StaticHeightDataProvider { }

extension SecurityLevelTableViewCellDataProvider {
    var identifier: String { SecurityLevelTableViewCell.identifierValue }
    var height: CGFloat {
        get { 54 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultSecurityLevelComponentViewModel: SecurityLevelTableViewCellDataProvider { }
