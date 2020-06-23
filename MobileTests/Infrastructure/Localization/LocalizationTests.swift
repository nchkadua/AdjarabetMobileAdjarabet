//
//  LocalizationTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 4/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class LocalizationTests: XCTestCase {
    func testLocalized() {
        XCTAssertNotEqual(R.string.localization.login.localized(language: .english), "Login")
//        XCTAssertEqual(R.string.localization.login.localized(language: .georgian), "შესვლა")
//        XCTAssertEqual(R.string.localization.login.localized(language: .armenian), "մուտք")
    }
}
