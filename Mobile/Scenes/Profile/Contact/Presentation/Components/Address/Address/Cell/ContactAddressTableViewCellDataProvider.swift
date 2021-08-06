//
//  ContactAddressTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol ContactAddressTableViewCellDataProvider: AppCellDelegate, ContactAddressComponentViewModel, StaticHeightDataProvider { }

public extension ContactAddressTableViewCellDataProvider {
    var identifier: String { ContactAddressTableViewCell.identifierValue }
    var height: CGFloat {
        get { 100 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultContactAddressComponentViewModel: ContactAddressTableViewCellDataProvider { }
