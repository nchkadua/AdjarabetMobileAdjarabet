//
//  QuickActionTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol QuickActionTableViewCellDataProvider: AppCellDelegate, QuickActionComponentViewModel, StaticHeightDataProvider { }

public extension QuickActionTableViewCellDataProvider {
    var identifier: String { QuickActionTableViewCell.identifierValue }
}

extension DefaultQuickActionComponentViewModel: QuickActionTableViewCellDataProvider { }

public extension DefaultQuickActionComponentViewModel {
    var height: CGFloat {
        get {
            54
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
