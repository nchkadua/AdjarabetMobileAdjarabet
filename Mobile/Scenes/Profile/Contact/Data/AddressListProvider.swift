//
//  AddressListProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class AddressListProvider {
    public static func list() -> [Address] {
        return [
            Address(title: "თბილისი, საქართველო 26 მაისის მოედანი #1 ", city: "თბილისი ჩემიკააი", coordinates: .init(latitude: 41.716667, longitude: 44.783333)),
            Address(title: "თბილისი, საქართველო 26 მაისის მოედანი #1 ", city: "ზუგდიდი წიეე", coordinates: .init(latitude: 42.5088, longitude: 41.8709)),
            Address(title: "თბილისი, საქართველო 26 მაისის მოედანი #1 ", city: "ქუთეეისი სიმონ", coordinates: .init(latitude: 42.26791, longitude: 42.69459)),
            Address(title: "თბილისი, საქართველო 26 მაისის მოედანი #1 ", city: "სვნთთიიი!!!", coordinates: .init(latitude: 42.909829694, longitude: 43.006833306))
        ]
    }
}

public struct Address {
    let title: String
    let city: String
    let coordinates: Coordinates
}

struct Coordinates {
    let latitude: CGFloat
    let longitude: CGFloat
}
