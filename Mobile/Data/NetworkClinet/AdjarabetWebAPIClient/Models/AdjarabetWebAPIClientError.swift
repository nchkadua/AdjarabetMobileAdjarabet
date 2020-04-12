//
//  AdjarabetWebAPIClientError.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum AdjarabetWebAPIClientError: Swift.Error {
    case dataIsEmpty(context: URL)
}

extension AdjarabetWebAPIClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataIsEmpty(let context):
            return NSLocalizedString("Data was empty \(context)", comment: "Adjarabet Core Error")
        }
    }
}
