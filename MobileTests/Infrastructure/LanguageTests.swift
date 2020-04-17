//
//  LanguageTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 4/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class LanguageTests: XCTestCase {
    func testLocalizableIdentifier() {
        XCTAssertEqual(Language.english.localizableIdentifier, "en")
        XCTAssertEqual(Language.georgian.localizableIdentifier, "ka")
        XCTAssertEqual(Language.armenian.localizableIdentifier, "hy")
    }
}
