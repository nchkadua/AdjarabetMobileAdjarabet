//
//  FooterTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol FooterTableViewCellDataProvider: FooterComponentViewModel, StaticHeightDataProvider { }

public extension FooterTableViewCellDataProvider {
    var identifier: String { FooterTableViewCell.identifierValue }
}

extension DefaultFooterComponentViewModel: FooterTableViewCellDataProvider { }

public extension DefaultFooterComponentViewModel {
    var height: CGFloat {
        get {
            169
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
