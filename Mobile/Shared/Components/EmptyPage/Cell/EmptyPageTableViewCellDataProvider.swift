//
//  EmptyPageTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol EmptyPageTableViewCellDataProvider: EmptyPageComponentViewModel, StaticHeightDataProvider { }

public extension EmptyPageTableViewCellDataProvider {
    var identifier: String { EmptyPageTableViewCell.identifierValue }
    var height: CGFloat {
        get { 36 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultEmptyPageComponentViewModel: EmptyPageTableViewCellDataProvider { }
