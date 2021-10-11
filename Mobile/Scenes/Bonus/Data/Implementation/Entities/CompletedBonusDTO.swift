//
//  CompletedBonusDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CompletedBonusDTO: DataTransferResponse {
    struct Body: Codable {
        let items: [CompletedBonusEntity]?
        let itemCount: Int
        let pageCount: Int
        let itemsPerPage: Int

        struct CompletedBonusEntity: Codable {
            let name: String
            let startDate: String
            let endDate: String?
            let condition: String?
            let gameId: Int?

            enum CodingKeys: String, CodingKey {
                case name
                case startDate
                case endDate
                case condition
                case gameId
            }
        }

        enum CodingKeys: String, CodingKey {
            case items
            case itemCount
            case pageCount
            case itemsPerPage
        }
    }

    typealias Entity = CompletedBonusEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let list = body.items else { return nil }

        var activeBonuses: [CompletedBonusEntity.BonusEntity] = []
        list.forEach {
            let bonus = CompletedBonusEntity.BonusEntity(name: $0.name, startDate: $0.startDate, endDate: $0.endDate ?? "", condition: $0.condition, gameId: $0.gameId ?? 0)
            activeBonuses.append(bonus)
        }

        return .success(.init(items: activeBonuses, itemCount: body.itemCount, pageCount: body.pageCount, itemsPerPage: body.itemsPerPage))
    }
}
