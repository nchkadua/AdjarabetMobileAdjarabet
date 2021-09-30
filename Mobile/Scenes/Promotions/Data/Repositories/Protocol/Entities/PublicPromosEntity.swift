//
//  PublicPromosEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct PublicPromosEntity {
    var list: [PublicPromo]

    public struct PublicPromo {
        let image: String
        let url: String
    }
}
