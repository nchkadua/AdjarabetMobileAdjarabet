//
//  AccessListEntity.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct AccessListEntity {
    public let ip: String
    public let userAgent: String
    public let date: Date

    public init?(ip: String?, userAgent: String?, date: Date?) {
        guard let ip = ip, let userAgent = userAgent, let date = date else { return nil }
        self.ip = ip
        self.userAgent = userAgent
        self.date = date
    }
}
