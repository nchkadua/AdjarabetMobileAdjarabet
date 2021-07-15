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
            /* Segments */
            let applePay: [String]?
            let segmentList: [String]?
            let segmentListEmoney: [String]?
            /* Desired Values for result */
            let methodType: String?
            let flowId: String?
            let iconUrl: String?
            let downtimeId: String?
            let channelId: String?

            enum CodingKeys: String, CodingKey {
                case applePay = "Apple_Pay"
                case segmentList
                case segmentListEmoney
                case methodType
                case flowId
                case iconUrl = "img"
                case downtimeId
                case channelId
            }
        }

        enum CodingKeys: String, CodingKey {
            case list
        }
    }

    typealias Entity = PaymentListEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let list = body.list else { return nil }

        var elements: [PaymentListEntity.ElementEntity] = []

        list.forEach {
            if let methodType = $0.methodType,
               let flowId = $0.flowId,
               let iconUrl = $0.iconUrl,
               let downtimeId = $0.downtimeId,
               let channelId = $0.channelId {
                // Create element entity
                let element = PaymentListEntity.ElementEntity(
                    applePay: $0.applePay,
                    segmentList: $0.segmentList,
                    segmentListEmoney: $0.segmentListEmoney,
                    method: .init(
                        methodType: methodType,
                        flowId: flowId,
                        iconUrl: iconUrl,
                        downtimeId: downtimeId,
                        channelId: channelId
                    )
                )
                // Append to list
                elements.append(element)
            }
        }

        return .success(.init(elements: elements))
    }
}
