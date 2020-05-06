//
//  DesignSystemTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 4/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class DesignSystemTests: XCTestCase {
    func testColors() {
        /// Neutral colors
        XCTAssertEqual(DesignSystem.Color.white.value, R.color.colorGuide.neutral.white()!)
        XCTAssertEqual(DesignSystem.Color.neutral100.value, R.color.colorGuide.neutral.neutral100()!)
        XCTAssertEqual(DesignSystem.Color.neutral200.value, R.color.colorGuide.neutral.neutral200()!)
        XCTAssertEqual(DesignSystem.Color.neutral300.value, R.color.colorGuide.neutral.neutral300()!)
        XCTAssertEqual(DesignSystem.Color.neutral400.value, R.color.colorGuide.neutral.neutral400()!)
        XCTAssertEqual(DesignSystem.Color.neutral500.value, R.color.colorGuide.neutral.neutral500()!)
        XCTAssertEqual(DesignSystem.Color.neutral600.value, R.color.colorGuide.neutral.neutral600()!)
        XCTAssertEqual(DesignSystem.Color.neutral700.value, R.color.colorGuide.neutral.neutral700()!)
        XCTAssertEqual(DesignSystem.Color.neutral800.value, R.color.colorGuide.neutral.neutral800()!)
        XCTAssertEqual(DesignSystem.Color.neutral900.value, R.color.colorGuide.neutral.neutral900()!)

        /// Primary colors
        XCTAssertEqual(DesignSystem.Color.primary200.value, R.color.colorGuide.primary.primary200()!)
        XCTAssertEqual(DesignSystem.Color.primary400.value, R.color.colorGuide.primary.primary400()!)

        /// Secondary colors
        XCTAssertEqual(DesignSystem.Color.secondary200.value, R.color.colorGuide.secondary.secondary200()!)
        XCTAssertEqual(DesignSystem.Color.secondary400.value, R.color.colorGuide.secondary.secondary400()!)

        /// Semantic colors
        XCTAssertEqual(DesignSystem.Color.success.value, R.color.colorGuide.semantic.success()!)
        XCTAssertEqual(DesignSystem.Color.warning.value, R.color.colorGuide.semantic.warning()!)
        XCTAssertEqual(DesignSystem.Color.error.value, R.color.colorGuide.semantic.error()!)
    }

    func testTypography() {
        Language.allCases.forEach { language in
            DefaultLanguageStorage.shared.update(language: language)
            
            var upperHeaderFontName: String!
            var lowerHeaderFontName: String!
            
            switch language {
            case .georgian:
                upperHeaderFontName = R.font.pantonMtav3Bold.fontName
                lowerHeaderFontName = R.font.pantonNusx3Bold.fontName
            case .armenian:
                upperHeaderFontName = R.font.pantonAMBold.fontName
                lowerHeaderFontName = R.font.pantonAMBold.fontName
            case .english:
                upperHeaderFontName = R.font.pantonMtav3Bold.fontName
                lowerHeaderFontName = R.font.pantonMtav3Bold.fontName
            }
            
            func testDescription(typography: DesignSystem.Typography, pointSize: CGFloat, lineSpasing: CGFloat, lineHeight: CGFloat) {
                XCTAssertEqual(typography.description.font.pointSize, pointSize)
                XCTAssertEqual(typography.description.lineSpasing, lineSpasing)
                XCTAssertEqual(typography.description.lineHeight, lineHeight)
            }

            XCTAssertEqual(DesignSystem.Typography.h1(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h1(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h1(fontCase: .lower), pointSize: 28, lineSpasing: 0.7, lineHeight: 44)
            testDescription(typography: .h1(fontCase: .upper), pointSize: 28, lineSpasing: 0.7, lineHeight: 44)

            XCTAssertEqual(DesignSystem.Typography.h2(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h2(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h2(fontCase: .lower), pointSize: 23, lineSpasing: 0.7, lineHeight: 36)
            testDescription(typography: .h2(fontCase: .upper), pointSize: 23, lineSpasing: 0.7, lineHeight: 36)

            XCTAssertEqual(DesignSystem.Typography.h3(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h3(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h3(fontCase: .lower), pointSize: 16, lineSpasing: 0.5, lineHeight: 24)
            testDescription(typography: .h3(fontCase: .upper), pointSize: 16, lineSpasing: 0.5, lineHeight: 24)

            XCTAssertEqual(DesignSystem.Typography.h4(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h4(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h4(fontCase: .lower), pointSize: 14, lineSpasing: 0.3, lineHeight: 24)
            testDescription(typography: .h4(fontCase: .upper), pointSize: 14, lineSpasing: 0.3, lineHeight: 24)

            XCTAssertEqual(DesignSystem.Typography.h5(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h5(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h5(fontCase: .lower), pointSize: 11, lineSpasing: 0.5, lineHeight: 16)
            testDescription(typography: .h5(fontCase: .upper), pointSize: 11, lineSpasing: 0.5, lineHeight: 16)
            
            XCTAssertEqual(DesignSystem.Typography.body1.description.font.fontName, R.font.firaGOMedium.fontName)
            XCTAssertEqual(DesignSystem.Typography.body1.description.font.pointSize, 13)
            XCTAssertEqual(DesignSystem.Typography.body1.description.lineSpasing, 0)
            XCTAssertEqual(DesignSystem.Typography.body1.description.lineHeight, 20)
            
            XCTAssertEqual(DesignSystem.Typography.body2.description.font.fontName, R.font.firaGOMedium.fontName)
            XCTAssertEqual(DesignSystem.Typography.body2.description.font.pointSize, 11)
            XCTAssertEqual(DesignSystem.Typography.body2.description.lineSpasing, 0)
            XCTAssertEqual(DesignSystem.Typography.body2.description.lineHeight, 16)
            
            XCTAssertEqual(DesignSystem.Typography.p.description.font.fontName, R.font.firaGORegular.fontName)
            XCTAssertEqual(DesignSystem.Typography.p.description.font.pointSize, 13)
            XCTAssertEqual(DesignSystem.Typography.p.description.lineSpasing, 0)
            XCTAssertEqual(DesignSystem.Typography.p.description.lineHeight, 20)
        }
    }
    
    func testSpacing() {
        XCTAssertEqual(DesignSystem.Spacing.space4.value, 4)
        XCTAssertEqual(DesignSystem.Spacing.space8.value, 8)
        XCTAssertEqual(DesignSystem.Spacing.space12.value, 12)
        XCTAssertEqual(DesignSystem.Spacing.space16.value, 16)
        XCTAssertEqual(DesignSystem.Spacing.space20.value, 20)
        XCTAssertEqual(DesignSystem.Spacing.space24.value, 24)
        XCTAssertEqual(DesignSystem.Spacing.space28.value, 28)
        XCTAssertEqual(DesignSystem.Spacing.space32.value, 32)
    }
}
