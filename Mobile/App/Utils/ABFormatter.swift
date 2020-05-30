//
//  ABFormatter.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ABFormatter {
    public static let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.groupingSeparator = ","
        f.groupingSize = 3
        f.usesGroupingSeparator = true
        f.decimalSeparator = "."
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.locale = Locale(identifier: "en_US")
        return f
    }()
}

public extension Double {
    var formattedBalance: String? {
        guard let formatted = ABFormatter.priceFormatter.string(from: NSNumber(value: self)) else {return nil}
        return "₾ \(formatted)"
    }
}
