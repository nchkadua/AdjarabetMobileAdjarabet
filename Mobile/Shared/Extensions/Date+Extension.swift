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
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }

    var formattedStringValue: String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "d MMMM"
        return formatter3.string(from: self)
    }

    var formattedStringFullValue: String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "d MMMM HH:MM:SS"
        return formatter3.string(from: self)
    }

    var formattedStringTimeValue: String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:MM:SS"
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

    static func minutesBetweenDates(_ date1: Date, _ date2: Date) -> CGFloat {
        CGFloat(date2.timeIntervalSinceReferenceDate/60 - date1.timeIntervalSinceReferenceDate/60)
    }

    var daysLeftTexted: String {
        let daysText = Int(timeIntervalSinceNow) / 60 / 60 / 24
        return "\(daysText) \(R.string.localization.day.localized())"
    }

    var clockLeftTexted: String {
        let numTotalSecondsLeft = Int(self.timeIntervalSinceNow)
        let numTotalMinutesLeft = numTotalSecondsLeft / 60
        let numTotalHoursLeft = numTotalMinutesLeft / 60

        let numSecondsLeft = numTotalSecondsLeft % 60
        let numMinutesLeft = numTotalMinutesLeft % 60
        let numHoursLeft = numTotalHoursLeft % 24

        let secondsText = (numSecondsLeft < 10 ? "0" : "") + "\(numSecondsLeft)"
        let minutesText = (numMinutesLeft < 10 ? "0" : "") + "\(numMinutesLeft)"
        let hoursText = (numHoursLeft < 10 ? "0" : "") + "\(numHoursLeft)"

        return "\(hoursText):\(minutesText)" // TODO: secondsText?
    }

    var timeLeftTexted: String {
        "\(daysLeftTexted) \(clockLeftTexted)"
    }

    var isPast: Bool {
        timeIntervalSinceNow.sign == .minus
    }

    var isFuture: Bool {
        timeIntervalSinceNow.sign == .plus
    }
}
