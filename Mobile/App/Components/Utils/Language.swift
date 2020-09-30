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

    public var flag: String {
        switch self {
        case .english: return "🇬🇧"
        case .georgian: return "🇬🇪"
        case .armenian: return "🇦🇲"
        }
    }

    public var title: String {
        switch self {
        case .english: return "ENG"
        case .georgian: return "GEO"
        case .armenian: return "AMD"
        }
    }

    public func next() -> Language {
        return Language.allCases[(Language.allCases.firstIndex(of: self)! + 1) % Language.allCases.count]
    }

    public static var `default`: Language { .english }

    public class Class { }
}
