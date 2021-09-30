//
//  PublicPromosDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PublicPromosDTO: DataTransferResponse {
    struct Body: Codable {
        let list: [PublicPromoEntity]?

        struct PublicPromoEntity: Codable {
            public var image: String?
            public var url: String?

            enum CodingKeys: String, CodingKey {
                case image
                case url
            }
        }

        enum CodingKeys: String, CodingKey {
            case list
        }
    }

    typealias Entity = PublicPromosEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let list = body.list else { return nil }

        var promos: [PublicPromosEntity.PublicPromo] = []

        list.forEach {
            if let image = $0.image,
               let url = $0.url {
                let promo = PublicPromosEntity.PublicPromo(image: image, url: url)
                promos.append(promo)
            }
        }

        return .success(.init(list: promos))
    }
}
