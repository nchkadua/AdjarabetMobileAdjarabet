//
//  QuickActionsHeaderCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol QuickActionsHeaderCellDataProvider: QuickActionsHeaderViewModel, StaticHeightDataProvider { }

public extension QuickActionsHeaderCellDataProvider {
    var identifier: String { QuickActionsHeaderCell.identifierValue }
}

extension DefaultQuickActionsHeaderViewModel: QuickActionsHeaderCellDataProvider {
}

public extension QuickActionsHeaderCellDataProvider {
    var height: CGFloat {
        get {
            53
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
