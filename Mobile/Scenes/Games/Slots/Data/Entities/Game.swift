//
//  Game.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/4/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct Game {
    public var id: String // TODO: let
    public let coverUrl: URL
    public let name: String
    public let category: String
    public let jackpot: String?
}

extension Game: Codable {
}

public struct Games {
    public let games: [Game]
}

extension Games: Codable {
}
