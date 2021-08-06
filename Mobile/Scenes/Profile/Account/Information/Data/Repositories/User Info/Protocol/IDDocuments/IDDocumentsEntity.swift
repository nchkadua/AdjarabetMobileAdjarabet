//
//  IDDocumentsEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 28.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct IDDocumentsEntity {
    let statusCode: Int
    let idDocuments: [IDDocument]

    struct IDDocument {
        let id: Int
        let documentTypeID: Int
        let documentNumber: String
        let personalID: String
//        let documentCountryID: String
        let dataModified: String
        let documentStatus: Int
//        let documentFrontImageUrl: String?
//        let documentBackImageUrl: String?
//        let documentExpirationDate: String?
    }
}
