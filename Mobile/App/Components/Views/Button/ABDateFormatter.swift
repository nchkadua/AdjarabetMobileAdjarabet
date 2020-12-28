//
//  ABDateFormatter.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

//private lazy var dayDateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.locale = Locale(identifier: "en_US_POSIX")
//    formatter.timeZone = TimeZone(secondsFromGMT: 0)
//    formatter.dateFormat = "yyyy-MM-dd"
//    return formatter
//}()
//
//private lazy var hourDateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.locale = Locale(identifier: "en_US_POSIX")
//    formatter.timeZone = TimeZone(secondsFromGMT: 0)
//    formatter.dateFormat = "HH:mm:ss"
//    return formatter
//}()

class ABDateFormater: DateFormatter {
    enum Formatting {
        case day
        case hour
        case verbose
    }
    public init(with formatting: Formatting) {
        super.init()
        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone(secondsFromGMT: 0)
        setFormmatting(formatting)
    }

    private func setFormmatting(_ formatting: Formatting) {
        switch formatting {
        case .day:
            dateFormat = "yyyy-MM-dd"
        case .hour:
            dateFormat = "HH:mm:ss"
        case .verbose:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
