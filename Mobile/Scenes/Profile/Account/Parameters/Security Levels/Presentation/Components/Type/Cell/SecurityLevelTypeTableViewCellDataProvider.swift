//
//  SecurityLevelTypeTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol SecurityLevelTypeTableViewCellDataProvider: SecurityLevelTypeComponentViewModel, StaticHeightDataProvider { }

public extension SecurityLevelTypeTableViewCellDataProvider {
    var identifier: String { SecurityLevelTypeTableViewCell.identifierValue }
    var height: CGFloat {
        get { 60 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultSecurityLevelTypeComponentViewModel: SecurityLevelTypeTableViewCellDataProvider { }
