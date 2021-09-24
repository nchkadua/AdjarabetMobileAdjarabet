//
//  ContactEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 24.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct ContactEntity {
    let phones: [String]
    let contactMail: String
    let docsMail: String
    let addresses: [ContactAddress]
}

public struct ContactAddress {
    let cityName: String
    let address: String
    let coordinates: Coordinates

    public struct Coordinates {
        let latitude: String
        let longitude: String
    }
}
