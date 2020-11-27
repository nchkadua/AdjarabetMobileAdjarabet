//
//  UserInfoDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class UserInfoDataTransferResponse: DataTransferResponse {
    /*
    public struct Header: HeaderProtocol {
        public init(headers: [AnyHashable: Any]?) throws {
            ...
        }
    }
    */
    public struct Body: Codable { }

    public typealias Entity = UserInfoEntity

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity {
        UserInfoEntity()
    }
}
