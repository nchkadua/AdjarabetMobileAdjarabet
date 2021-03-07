//
//  PaymentListDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentListDTO: DataTransferResponse {
    struct Body: Codable {
        let list: [PaymentMethod]?

        struct PaymentMethod: Codable {
            let applePay: [String]?
            let segmentList: [String]?
            let segmentListEmoney: [String]?

            enum CodingKeys: String, CodingKey {
                case applePay = "Apple_Pay"
                case segmentList // = "segmentList"
                case segmentListEmoney // = "segmentListEmoney"
            }
        }

        enum CodingKeys: String, CodingKey {
            case list
        }
    }

    typealias Entity = PaymentListEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        guard let list = body.list else { return nil }
        return .init (
            methods: list.map {
                PaymentMethodEntity (
                    applePay: $0.applePay,
                    segmentList: $0.segmentList,
                    segmentListEmoney: $0.segmentListEmoney
                )
            }
        )
    }
}
