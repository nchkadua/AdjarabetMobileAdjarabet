//
//  LanguageStorage.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol LanguageStorage: LanguageReadableStorage, LanguageUpdatableStorage {
}

public protocol LanguageReadableStorage {
    var currentLanguage: Language { get }
    var currentLanguageObservable: Observable<Language> { get }
}

public protocol LanguageUpdatableStorage {
    func update(language: Language)
}

public class DefaultLanguageStorage {
    public static let shared = DefaultLanguageStorage()
    private let currentLanguageSubject = PublishSubject<Language>()

    @ABUserDefaults(Key.language.rawValue, defaultValue: nil)
    private var language: Int? {
        didSet {
            currentLanguageSubject.onNext(currentLanguage)
        }
    }

    public enum Key: String {
        case language = "com.adjarabet.mobile.storage.language"
    }
}

extension DefaultLanguageStorage: LanguageStorage {
    public var currentLanguage: Language {
        Language(rawValue: language ?? -1) ?? .default
    }

    public var currentLanguageObservable: Observable<Language> {
        currentLanguageSubject.asObservable().distinctUntilChanged()
    }

    public func update(language: Language) {
        self.language = language.rawValue
    }
}
