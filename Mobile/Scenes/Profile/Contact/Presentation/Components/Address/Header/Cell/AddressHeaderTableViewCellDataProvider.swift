//
//  AddressHeaderTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol AddressHeaderTableViewCellDataProvider: AddressHeaderComponentViewModel, StaticHeightDataProvider { }

public extension AddressHeaderTableViewCellDataProvider {
    var identifier: String { AddressHeaderTableViewCell.identifierValue }
    var height: CGFloat {
        get { 50 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultAddressHeaderComponentViewModel: AddressHeaderTableViewCellDataProvider { }
