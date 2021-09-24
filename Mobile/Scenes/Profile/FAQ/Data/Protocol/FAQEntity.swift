//
//  FAQEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 22.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct FAQEntity {
    let categories: [FAQCategory]
}

public struct FAQCategory {
    let icon: String
    let title: String
    let description: String
    let questions: [FAQQuestion]
}

public struct FAQQuestion {
    let title: String
    let answer: String
}
