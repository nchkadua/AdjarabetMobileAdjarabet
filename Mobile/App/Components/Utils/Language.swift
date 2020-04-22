//
//  Language.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum Language: Int, CaseIterable {
    case english
    case georgian
    case armenian

    public var localizableIdentifier: String {
        switch self {
        case .english: return "en"
        case .georgian: return "ka"
        case .armenian: return "hy"
        }
    }

    public static var `default`: Language { .english }

    public class Class { }
}
