//
//  DateFormatter+Extension.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

extension DateFormatter {
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
