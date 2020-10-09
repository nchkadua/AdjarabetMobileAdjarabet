//
//  ProfileInfoTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol ProfileInfoTableViewCellDataProvider: ProfileInfoComponentViewModel, StaticHeightDataProvider { }

public extension ProfileInfoTableViewCellDataProvider {
    var identifier: String { ProfileInfoTableViewCell.identifierValue }
}

extension DefaultProfileInfoComponentViewModel: ProfileInfoTableViewCellDataProvider {
}

public extension ProfileInfoTableViewCellDataProvider {
    var height: CGFloat {
        get {
            130
        }
        set {
            print(newValue)
        }
    }

    var isHeightSet: Bool {
        true
    }
}
