//
//  MyCardable.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol MyCardable {}

struct MyCardsTable {
    private let dummyVisaCard: MyCard = .card(issuer: .visa, bank: .tbc, number: "548888••••5149", dateAdded: Date())
    private let dummyMCCard: MyCard = .card(issuer: .masterCard, bank: .bog, number: "345588••••7174", dateAdded: Date())
    private let dummyAddCards: AddCard = AddCard()
    private let dummyVideoCards: VideoCard = VideoCard()
    var dataSource: [MyCardable] = []
    init() {
        dataSource = [
            dummyVisaCard,
            dummyMCCard,
            dummyAddCards,
            dummyVideoCards,
        ]
    }
}
