//
//  AdjarabetWebAPICodable.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetWebAPICodable {
    public struct UserLoggedIn: Codable {
        public let success, statusCode: Int
        public let data: DataClass

        public struct DataClass: Codable {
            public let amountSuggestions, widgetOrder: [String]

            enum CodingKeys: String, CodingKey {
                case amountSuggestions
                case widgetOrder = "WidgetOrder"
            }
        }
    }
}
