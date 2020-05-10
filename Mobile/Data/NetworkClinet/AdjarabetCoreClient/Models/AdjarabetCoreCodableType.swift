//
//  AdjarabetCoreCodableType.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AdjarabetCoreCodableType {
    associatedtype T where T: Codable
    associatedtype H where H: HeaderProtocol

    var codable: T { get }
    var header: H? { get }
    init(codable: T, header: H?)
    static func validate(data: Data) throws
}

public protocol HeaderProtocol {
    init(headers: [AnyHashable: Any]?) throws
}

public extension AdjarabetCoreCodableType {
    static func validate(data: Data) throws {
        let statusCode = try JSONDecoder().decode(AdjarabetCoreCodable.StatusCodeChecker.self, from: data)

        if !statusCode.isSuccess {
            throw AdjarabetCoreClientError.invalidStatusCode(code: statusCode.code)
        }
    }
}
