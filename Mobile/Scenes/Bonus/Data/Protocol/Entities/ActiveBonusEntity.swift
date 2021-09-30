//
//  ActiveBonusEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct ActiveBonusEntity {
    var items: [BonusEntity]
    var itemCount: Int
    var pageCount: Int
    var itemsPerPage: Int

    public struct BonusEntity {
        var name: String
        var startDate: String
        var endDate: String?
        var condition: String
        var gameId: Int?
    }
}
