//
//  WebApiPaymentAccountDeleteDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct WebApiPaymentAccountDeleteDTO: DataTransferResponse {
    struct Body: Codable {
        let success: Int

        enum CodingKeys: String, CodingKey {
            case success
        }
    }

    typealias Entity = Void

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        if body.success == 1 { // FIXME: make common
            return (())
        } else {
            return nil
        }
    }
}
