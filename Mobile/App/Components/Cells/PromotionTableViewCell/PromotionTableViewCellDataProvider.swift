//
//  PromotionTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol PromotionTableViewCellDataProvider: PromotionComponentViewModel, StaticHeightDataProvider { }
private let aspectMagicNumber: CGFloat = 0.87 // Banner height aspect ratio

public extension PromotionTableViewCellDataProvider {
    var identifier: String { PromotionTableViewCell.identifierValue }
}

extension DefaultPromotionComponentViewModel: PromotionTableViewCellDataProvider { }

public extension PromotionTableViewCellDataProvider {
    var height: CGFloat {
        get {
            UIScreen.main.bounds.width / aspectMagicNumber
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
