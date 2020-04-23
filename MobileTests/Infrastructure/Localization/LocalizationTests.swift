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
        XCTAssertEqual(R.string.localization.join_now.localized(), "Join Now")
        XCTAssertEqual(R.string.localization.join_now.localized(language: .english), "Join Now")
        XCTAssertEqual(R.string.localization.join_now.localized(language: .georgian), "რეგისტრაცია")
        XCTAssertEqual(R.string.localization.join_now.localized(language: .armenian), "գրանցվել")
    }
}
