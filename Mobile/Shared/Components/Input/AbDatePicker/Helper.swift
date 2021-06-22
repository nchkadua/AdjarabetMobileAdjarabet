//
//  Helper.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class Helper {
    public static func months() -> [String] {
//        [
//            R.string.localization.january.localized(),
//            R.string.localization.february.localized(),
//            R.string.localization.march.localized(),
//            R.string.localization.april.localized(),
//            R.string.localization.may.localized(),
//            R.string.localization.june.localized(),
//            R.string.localization.july.localized(),
//            R.string.localization.august.localized(),
//            R.string.localization.september.localized(),
//            R.string.localization.october.localized(),
//            R.string.localization.november.localized(),
//            R.string.localization.december.localized()
//        ]
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    }

    public static func years() -> [String] {
        let formatter = DateFormatter()
        let currentYear = Calendar.current.component(.year, from: Date())
        let date = Calendar.current.date(byAdding: .year, value: 20, to: Date())
        let nextYearRange = Calendar.current.component(.year, from: date ?? Date())

        return formatter.years(currentYear...nextYearRange, format: "yyyy")
    }
}
