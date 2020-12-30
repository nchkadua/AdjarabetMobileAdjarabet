//
//  AmountFormatter.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class AmountFormatter: Formatter {
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    public func formatted(string: String) -> String {
        if !string.isEmpty,
            let number = formatter.number(from: string) {
            return formatter.string(from: number)!
        } else {
            return ""
        }
    }
}
