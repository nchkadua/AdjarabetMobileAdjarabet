//
//  PrivatePromosEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct PrivatePromosEntity {
    var list: [PrivatePromo]

    public struct PrivatePromo {
        let image: String
        let url: String
    }
}
