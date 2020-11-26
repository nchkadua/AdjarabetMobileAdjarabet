//
//  Formatter.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol Formatter {
    func formatted(string: String) -> String
}

// MARK: Default Formatter
public class DefaultFormatter: Formatter {
    public func formatted(string: String) -> String { string }
}
