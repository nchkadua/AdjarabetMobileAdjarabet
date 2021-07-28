//
//  IDDocumentsDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 28.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class IDDocumentsDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: String
        let idDocuments: [IDDocument]?

        struct IDDocument: Codable {
            let id: Int?
            let documentTypeID: String?
            let documentNumber: String?
            let personalID: String?
            let countryID: String?
            let dataModified: String?
            let documentStatus: String?
            let documentFrontImageUrl: String?
            let documentBackImageUrl: String?
            let documentExpirationDate: String?

            enum CodingKeys: String, CodingKey {
                case id = "ID"
                case documentTypeID = "DocumentTypeID"
                case documentNumber = "DocumentNumber"
                case personalID = "PersonalID"
                case countryID = "CountryID"
                case dataModified = "DateModified"
                case documentStatus = "DocumentStatus"
                case documentFrontImageUrl = "DocumentFrontImageURL"
                case documentBackImageUrl = "DocumentBackImageURL"
                case documentExpirationDate = "DocumentExpirationDate"
            }
        }

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case idDocuments = "IDDocuments"
        }
    }

    typealias Entity = IDDocumentsEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let idDocuments = body.idDocuments else { return nil }
        var documents: [IDDocument] = []

        idDocuments.forEach {
            if let id = $0.id,
               let documentTypeID = $0.documentTypeID,
               let documentNumber = $0.documentNumber,
               let personalID = $0.personalID,
               let countryID = $0.countryID,
               let dataModified = $0.dataModified,
               let documentStatus = $0.documentStatus,
               let documentFrontImageUrl = $0.documentFrontImageUrl,
               let documentBackImageUrl = $0.documentBackImageUrl,
               let documentExpirationDate = $0.documentExpirationDate {
                let document = IDDocument(id: id,
                                          documentTypeID: documentTypeID,
                                          documentNumber: documentNumber,
                                          personalID: personalID,
                                          countryID: countryID,
                                          dataModified: dataModified,
                                          documentStatus: documentStatus,
                                          documentFrontImageUrl: documentFrontImageUrl,
                                          documentBackImageUrl: documentBackImageUrl,
                                          documentExpirationDate: documentExpirationDate)

                documents.append(document)
            }
        }
        return .success(.init(statusCode: body.statusCode, idDocuments: documents))
    }
}
