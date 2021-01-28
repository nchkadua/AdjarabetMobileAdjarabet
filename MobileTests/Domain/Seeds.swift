//
//  Seeds.swift
//  MobileTests
//
//  Created by Irakli Shelia on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

@testable import Mobile

struct Seeds {
    struct AccessHistory {
        static let log: [AccessListEntity] = []
        static let displayAccessListUseCaseParams = DisplayAccessListUseCaseParams(fromDate: "2020-12-16",
                                                           toDate: "2020-12-25")
    }
}
