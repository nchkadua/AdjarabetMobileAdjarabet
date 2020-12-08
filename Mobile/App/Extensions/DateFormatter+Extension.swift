//
//  DateFormatter+Extension.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

extension DateFormatter {
    func hourDateString(from date: Date) -> String {
        dateFormat = "HH:mm:ss"
        return string(from: date)
    }

    func hourDate(from string: String) -> Date? {
        dateFormat = "HH:mm:ss"
        return date(from: string) ?? Date()
    }

    func dayDateString(from date: Date) -> String {
        dateFormat = "yyyy-MM-dd"
        return string(from: date)
    }

    func dayDate(from string: String) -> Date? {
        dateFormat = "yyyy-MM-dd"
        return date(from: string)
    }

    func verboseDateString(from date: Date) -> String {
        dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return string(from: date)
    }

    func verboseDate(from string: String) -> Date? {
        dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return date(from: string) ?? Date()
    }

    func years<R: RandomAccessCollection>(_ range: R, format: String) -> [String] where R.Iterator.Element == Int {
        setLocalizedDateFormatFromTemplate(format)
        var comps = DateComponents(month: 1, day: 1)
        var res = [String]()
        for y in range {
            comps.year = y
            if let date = calendar.date(from: comps) {
                res.append(string(from: date))
            }
        }
        return res
    }
}
