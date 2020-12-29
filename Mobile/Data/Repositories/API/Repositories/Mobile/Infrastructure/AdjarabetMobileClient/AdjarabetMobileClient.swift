//
//  AdjarabetMobileClient.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetMobileClient {
    public let baseUrl: URL

    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    public var baseUrlComponents: URLComponents {
        URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
    }

    public enum Method: String {
        case games = "games"
        case recentlyPlayed = "games/recentlyPlayed"
    }
}
