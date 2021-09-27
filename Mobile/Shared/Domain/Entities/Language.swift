//
//  Language.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public enum Language: Int, CaseIterable {
    case english
    case georgian
    case armenian
    case russian

    public var localizableIdentifier: String {
        switch self {
        case .english: return "en"
        case .georgian: return "ka"
        case .armenian: return "hy"
        case .russian: return "ru"
        }
    }

    public var mobileApiLocalizableIdentifier: String {
        switch self {
        case .english: return "en"
        case .georgian: return "ge"
        case .armenian: return "en"
        case .russian: return "ru"
        }
    }

    public var flag: String {
        switch self {
        case .english: return "🇬🇧"
        case .georgian: return "🇬🇪"
        case .armenian: return "🇦🇲"
        case .russian: return "🇷🇺"
        }
    }

    public var languageIcon: UIImage {
        switch self {
        case .english: return R.image.flags.en() ?? UIImage()
        case .georgian: return R.image.flags.ka() ?? UIImage()
        case .armenian: return R.image.flags.hy() ?? UIImage()
        case .russian: return R.image.flags.ru() ?? UIImage()
        }
    }

    public var title: String {
        switch self {
        case .english: return "ENG"
        case .georgian: return "GEO"
        case .armenian: return "AMD"
        case .russian: return "RUS"
        }
    }

    public var currency: String {
        switch self {
        case .english: return "$"
        case .georgian: return "₾"
        case .armenian: return "֏"
        case .russian: return "₽"
        }
    }

    public func next() -> Language {
        return Language.allCases[(Language.allCases.firstIndex(of: self)! + 1) % Language.allCases.count]
    }

    public static var `default`: Language { .english }

    public class Class { }
}
