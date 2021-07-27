//
//  ContactMailTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol ContactMailTableViewCellDataProvider: AppCellDelegate, ContactMailComponentViewModel, StaticHeightDataProvider { }

public extension ContactMailTableViewCellDataProvider {
    var identifier: String { ContactMailTableViewCell.identifierValue }
    var height: CGFloat {
        get { 129 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultContactMailComponentViewModel: ContactMailTableViewCellDataProvider { }
