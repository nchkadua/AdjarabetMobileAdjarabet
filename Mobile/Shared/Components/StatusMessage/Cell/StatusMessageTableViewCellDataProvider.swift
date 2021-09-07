//
//  StatusMessageTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol StatusMessageTableViewCellDataProvider: StatusMessageComponentViewModel, StaticHeightDataProvider { }

public extension StatusMessageTableViewCellDataProvider {
    var identifier: String { StatusMessageTableViewCell.identifierValue }
    var height: CGFloat {
        get { 36 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultStatusMessageComponentViewModel: StatusMessageTableViewCellDataProvider { }
