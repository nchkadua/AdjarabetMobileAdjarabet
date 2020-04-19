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
        XCTAssertEqual(DesignSystem.Typography.h1.description.font.fontName, R.font.pantonMtav3Bold.fontName)
        XCTAssertEqual(DesignSystem.Typography.h1.description.font.pointSize, 28)
        XCTAssertEqual(DesignSystem.Typography.h1.description.lineSpasing, 0.7)
        XCTAssertEqual(DesignSystem.Typography.h1.description.lineHeight, 44)
        
        XCTAssertEqual(DesignSystem.Typography.h2.description.font.fontName, R.font.pantonMtav3Bold.fontName)
        XCTAssertEqual(DesignSystem.Typography.h2.description.font.pointSize, 23)
        XCTAssertEqual(DesignSystem.Typography.h2.description.lineSpasing, 0.7)
        XCTAssertEqual(DesignSystem.Typography.h2.description.lineHeight, 36)
        
        XCTAssertEqual(DesignSystem.Typography.h3.description.font.fontName, R.font.pantonMtav3Bold.fontName)
        XCTAssertEqual(DesignSystem.Typography.h3.description.font.pointSize, 16)
        XCTAssertEqual(DesignSystem.Typography.h3.description.lineSpasing, 0.5)
        XCTAssertEqual(DesignSystem.Typography.h3.description.lineHeight, 24)
        
        XCTAssertEqual(DesignSystem.Typography.h4.description.font.fontName, R.font.pantonMtav3Bold.fontName)
        XCTAssertEqual(DesignSystem.Typography.h4.description.font.pointSize, 14)
        XCTAssertEqual(DesignSystem.Typography.h4.description.lineSpasing, 0.3)
        XCTAssertEqual(DesignSystem.Typography.h4.description.lineHeight, 24)
        
        XCTAssertEqual(DesignSystem.Typography.h5.description.font.fontName, R.font.pantonMtav3Bold.fontName)
        XCTAssertEqual(DesignSystem.Typography.h5.description.font.pointSize, 11)
        XCTAssertEqual(DesignSystem.Typography.h5.description.lineSpasing, 0.5)
        XCTAssertEqual(DesignSystem.Typography.h5.description.lineHeight, 16)
        
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
    
    func testAttributedString() {
        let typography = DesignSystem.Typography.h1
        let attributedString = "Text".makeAttributedString(with: typography, alignment: .left)
        
        /// Retrieve attributes
        let attributes = attributedString.attributes(at: 0, effectiveRange: nil)

        /// Retrieve and test font
        if let font = attributes[.font] as? UIFont {
            XCTAssertEqual(font.fontName, typography.description.font.fontName)
            XCTAssertEqual(font.pointSize, typography.description.font.pointSize)
        }

        /// Retrieve and test style
        if let style = attributes[.paragraphStyle] as? NSParagraphStyle {
            XCTAssertEqual(style.lineSpacing, typography.description.lineSpasing)
            XCTAssertEqual(style.alignment, .left)
        }
    }
}
