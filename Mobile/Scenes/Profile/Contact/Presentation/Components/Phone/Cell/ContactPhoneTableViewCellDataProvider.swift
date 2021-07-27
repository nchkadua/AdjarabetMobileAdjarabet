//
//  ContactPhoneTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol ContactPhoneTableViewCellDataProvider: ContactPhoneComponentViewModel, StaticHeightDataProvider { }

public extension ContactPhoneTableViewCellDataProvider {
    var identifier: String { ContactPhoneTableViewCell.identifierValue }
    var height: CGFloat {
        get { 90 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultContactPhoneComponentViewModel: ContactPhoneTableViewCellDataProvider { }
