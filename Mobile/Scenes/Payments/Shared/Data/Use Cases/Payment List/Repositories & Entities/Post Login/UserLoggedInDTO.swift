//
//  UserLoggedInDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UserLoggedInDTO: DataTransferResponse {
    struct Body: Codable {
        let data: Data?

        struct Data: Codable {
            let applePay: [String]?
            let segmentList: [String]?
            let segmentListEmoney: [String]?

            enum CodingKeys: String, CodingKey {
                case applePay = "Apple_Pay"
                case segmentList // = "segmentList"
                case segmentListEmoney = "segmentlistemoney"
            }
        }

        enum CodingKeys: String, CodingKey {
            case data
        }
    }

    typealias Entity = UserLoggedInEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(.init(
            applePay: body.data?.applePay,
            segmentList: body.data?.segmentList,
            segmentListEmoney: body.data?.segmentListEmoney
        ))
    }
}
