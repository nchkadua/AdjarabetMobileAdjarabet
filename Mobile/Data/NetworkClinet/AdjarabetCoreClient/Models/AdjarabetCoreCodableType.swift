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
}

public protocol HeaderProtocol {
    init(headers: [AnyHashable: Any]?) throws
}
