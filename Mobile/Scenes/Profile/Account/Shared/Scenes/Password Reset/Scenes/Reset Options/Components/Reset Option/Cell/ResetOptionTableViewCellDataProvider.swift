//
//  ResetOptionTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol ResetOptionTableViewCellDataProvider: AppCellDelegate, ResetOptionComponentViewModel, StaticHeightDataProvider { }

public extension ResetOptionTableViewCellDataProvider {
    var identifier: String { ResetOptionTableViewCell.identifierValue }
    var height: CGFloat {
        get { 56 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultResetOptionComponentViewModel: ResetOptionTableViewCellDataProvider { }
