//
//  PromotionTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol PromotionTableViewCellDataProvider: AppCellDelegate, PromotionComponentViewModel, StaticHeightDataProvider { }

public extension PromotionTableViewCellDataProvider {
    var identifier: String { PromotionTableViewCell.identifierValue }
}

extension DefaultPromotionComponentViewModel: PromotionTableViewCellDataProvider { }

public extension PromotionTableViewCellDataProvider {
    var height: CGFloat {
        get {
            220
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
