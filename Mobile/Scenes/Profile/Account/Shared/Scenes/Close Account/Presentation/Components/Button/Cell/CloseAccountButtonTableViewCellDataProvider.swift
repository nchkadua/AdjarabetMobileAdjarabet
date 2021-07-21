//
//  CloseAccountButtonTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol CloseAccountButtonTableViewCellDataProvider: CloseAccountButtonComponentViewModel, StaticHeightDataProvider { }

public extension CloseAccountButtonTableViewCellDataProvider {
    var identifier: String { CloseAccountButtonTableViewCell.identifierValue }
    var height: CGFloat {
        get { 126 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultCloseAccountButtonComponentViewModel: CloseAccountButtonTableViewCellDataProvider { }
