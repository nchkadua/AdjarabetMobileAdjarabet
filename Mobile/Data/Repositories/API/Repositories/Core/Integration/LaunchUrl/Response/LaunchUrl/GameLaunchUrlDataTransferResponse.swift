//
//  GameLaunchUrlDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class GameLaunchUrlDataTransferResponse: DataTransferResponse {
    public struct Body: Codable {
        public let data: Data?

        public struct Data: Codable {
            public let url: String?

            enum CodingKeys: String, CodingKey {
                case url
            }
        }

        enum CodingKeys: String, CodingKey {
            case data
        }
    }

    public typealias Entity = GameLaunchUrlEntity

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity {
        Entity(url: body.data?.url)
    }
}
