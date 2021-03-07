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
        /*
        enum CodingKeys: String, CodingKey {

        }
        */
    }

    typealias Entity = UserLoggedInEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        .init()
    }
}
