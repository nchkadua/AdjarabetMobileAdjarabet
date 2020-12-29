//
//  AdjarabetCoreClientError.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum AdjarabetCoreClientError: Swift.Error {
    case dataIsEmpty(context: URL)
    case invalidHeader(context: [AnyHashable: Any]?)
    case invalidStatusCode(code: AdjarabetCoreStatusCode)
}

extension AdjarabetCoreClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code):
            return NSLocalizedString("Status Code \(code): \(code.rawValue)", comment: "Adjarabet Core Error")
        case .invalidHeader(let context):
            return NSLocalizedString("Invalid Header \(String(describing: context))", comment: "Adjarabet Core Error")
        case .dataIsEmpty(let context):
            return NSLocalizedString("Data was empty \(context)", comment: "Adjarabet Core Error")
        }
    }
}

public extension Error {
    var isSessionNotFound: Bool {
        if
            let error = self as? AdjarabetCoreClientError,
            case let AdjarabetCoreClientError.invalidStatusCode(code) = error,
            code == .SESSION_NOT_FOUND {
            return true
        }

        return false
    }
}
