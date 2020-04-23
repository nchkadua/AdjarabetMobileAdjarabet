//
//  LanguageStorageTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class LanguageStorageTests: XCTestCase {
    private var storage: LanguageStorage = DefaultLanguageStorage.shared

    override func setUpWithError() throws {
        clearStorage()
    }

    override func tearDownWithError() throws {
        clearStorage()
    }
    
    private func clearStorage() {
        UserDefaults.standard.removeObject(forKey: DefaultLanguageStorage.Key.language.rawValue)
    }

    func testUpdateLanguage() throws {
        // given
        XCTAssertEqual(storage.currentLanguage, .default)
        let language = Language.allCases.randomElement()!
        
        // when
        storage.update(language: language)
        
        // than
        XCTAssertEqual(storage.currentLanguage, language)
    }
    
    func testLanguageObservable() throws {
        // given
        let randomLanguage = Language.allCases.randomElement()!
        var language: Language!
        
        _ = storage.currentLanguageObservable.subscribe(onNext: { newLanguage in
            language = newLanguage
        })
        
        // when
        storage.update(language: randomLanguage)
        
        // than
        XCTAssertEqual(language, randomLanguage)
    }
}
