//
//  ContactDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 24.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct ContactDTO: DataTransferResponse {
    struct Body: Codable {
        let phones: [String]?
        let contactMail: String?
        let docsMail: String?
        let addresses: [ContactAddress]?

        struct ContactAddress: Codable {
            let cityName: String?
            let address: String?
            let coordinates: ContactAddressCoordinates

            struct ContactAddressCoordinates: Codable {
                let latitude: String?
                let longitude: String?

                enum CodingKeys: String, CodingKey {
                    case latitude
                    case longitude
                }
            }

            enum CodingKeys: String, CodingKey {
                case cityName
                case address
                case coordinates
            }
        }

        enum CodingKeys: String, CodingKey {
            case phones
            case contactMail
            case docsMail
            case addresses
        }
    }

    typealias Entity = ContactEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<ContactEntity, ABError>? {
        guard let phones = body.phones, let addresses = body.addresses else {return nil}

        var contactAddresses: [ContactAddress] = []
        addresses.forEach {
            if let cityName = $0.cityName,
               let address = $0.address,
               let latitude = $0.coordinates.latitude,
               let longitude = $0.coordinates.longitude {
                let address = ContactAddress(cityName: cityName, address: address, coordinates: .init(latitude: latitude, longitude: longitude))
                contactAddresses.append(address)
            }
        }

        return .success(.init(phones: phones, contactMail: body.contactMail ?? "", docsMail: body.contactMail ?? "", addresses: contactAddresses))
    }
}
