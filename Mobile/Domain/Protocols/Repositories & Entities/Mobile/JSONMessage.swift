//
//  JSONMessage.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct JSONMessage<T: Codable>: Codable {
    public let params: T

    private enum Keys: String, CodingKey {
        case params
        case error
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        let error = try? container.decode(ErrorMessage.self, forKey: .error)

        if let error = error {
            throw Error.server(error)
        }

        self.params = try container.decode(T.self, forKey: .params)
    }

    public struct ErrorMessage: Codable {
        public let code: Int
        public let description: Description?

        public struct Description: Codable {
            public let title: String?
            public let description: String?
        }
    }

    public enum Error: Swift.Error {
        case server(ErrorMessage)
        case parsing(Swift.Error)
    }
}
