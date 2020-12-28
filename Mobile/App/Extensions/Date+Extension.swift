//
//  Date+Extension.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

extension Date {
    static var today: Date { return Date().today }
    static var yesterday: Date { return Date().dayBefore }
    static var bYesterday: Date { return Date().bYesterday }

    var today: Date {
        Calendar.current.date(byAdding: .day, value: 0, to: noon)!
    }
    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var bYesterday: Date {
        Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var stringValue: String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "d MMMM"
        return formatter3.string(from: self)
    }

    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
}
