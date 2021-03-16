//
//  UFCWithdrawDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UFCWithdrawDTO: DataTransferResponse {
    struct Body: Codable {
        let code: Int

        enum CodingKeys: String, CodingKey {
            case code
        }
    }

    typealias Entity = Void

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        if body.code == 10 { return () }
        return nil
    }
}
