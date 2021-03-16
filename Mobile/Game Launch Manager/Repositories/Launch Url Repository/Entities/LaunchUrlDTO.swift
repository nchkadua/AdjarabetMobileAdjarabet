//
//  LaunchUrlDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct LaunchUrlDTO: DataTransferResponse {
    struct Body: Codable {
        let data: Data?

        struct Data: Codable {
            let url: String?

            enum CodingKeys: String, CodingKey {
                case url
            }
        }

        enum CodingKeys: String, CodingKey {
            case data
        }
    }

    typealias Entity = String

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? { body.data?.url }
}
