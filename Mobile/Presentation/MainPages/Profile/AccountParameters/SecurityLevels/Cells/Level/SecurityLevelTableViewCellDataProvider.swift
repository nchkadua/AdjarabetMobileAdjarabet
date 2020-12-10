//
//  SecurityLevelTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol SecurityLevelTableViewCellDataProvider: SecurityLevelComponentViewModel, StaticHeightDataProvider { }

public extension SecurityLevelTableViewCellDataProvider {
    var identifier: String { SecurityLevelTableViewCell.identifierValue }
    var height: CGFloat {
        get { 60 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultSecurityLevelComponentViewModel: SecurityLevelTableViewCellDataProvider { }
