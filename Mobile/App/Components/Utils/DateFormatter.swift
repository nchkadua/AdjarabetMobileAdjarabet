//
//  DateFormatter.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class ABDateFormatter {
    static func calendarDateFormatter(with localeIdentifier: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: localeIdentifier)

        return formatter
    }
}
