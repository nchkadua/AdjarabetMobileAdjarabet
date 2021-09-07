//
//  TitleDescriptionButtonTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol TitleDescriptionButtonTableViewCellDataProvider: TitleDescriptionButtonComponentViewModel, StaticHeightDataProvider { }

public extension TitleDescriptionButtonTableViewCellDataProvider {
    var identifier: String { TitleDescriptionButtonTableViewCell.identifierValue }
    var height: CGFloat {
        get { 36 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultTitleDescriptionButtonComponentViewModel: TitleDescriptionButtonTableViewCellDataProvider { }
