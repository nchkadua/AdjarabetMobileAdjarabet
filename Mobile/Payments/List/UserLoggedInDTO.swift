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

            enum CodingKeys: String, CodingKey {
                case applePay = "Apple_Pay"
            }
        }

        enum CodingKeys: String, CodingKey {
            case data
        }
    }

    typealias Entity = UserLoggedInEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        .init(applePay: body.data?.applePay)
    }
}
