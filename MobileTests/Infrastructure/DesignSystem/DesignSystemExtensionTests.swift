//
//  DesignSystemExtensionTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class DesignSystemExtensionTests: XCTestCase {
    // MAKR: UIButton
    func testButtonSetFont() {
        // given
        let typography = DesignSystem.Typography.body1
        let button = UIButton()
        
        // when
        button.setFont(to: typography)
        
        // than
        XCTAssertEqual(button.titleLabel?.font, typography.description.font)
    }
    
    func testButtonSetTitleColor() {
        // given
        let alpha = CGFloat.random(in: 0...1)
        let color = DesignSystem.Color.neutral100
        let button = UIButton()
        
        // when
        button.setTitleColor(to: color, for: .normal, alpha: alpha)
        
        // than
        XCTAssertEqual(button.titleColor(for: .normal), color.value.withAlphaComponent(alpha))
    }
    
    // MAKR: UIView
    func testViewSetBackgorundColor() {
        // given
        let color = DesignSystem.Color.neutral100
        let view = UIView()
        
        // when
        view.setBackgorundColor(to: color)
        
        // than
        XCTAssertEqual(view.backgroundColor, color.value)
    }
    
    func testViewSetTintColor() {
        // given
        let alpha = CGFloat.random(in: 0...1)
        let color = DesignSystem.Color.neutral100
        let view = UIView()
        
        // when
        view.setTintColor(to: color, alpha: alpha)
        
        // than
        XCTAssertEqual(view.tintColor, color.value.withAlphaComponent(alpha))
    }
    
    // MAKR: UILabel
    func testLabelSetFont() {
        // given
        let typography = DesignSystem.Typography.body1
        let label = UILabel()
        
        // when
        label.setFont(to: typography)
        
        // than
        XCTAssertEqual(label.font, typography.description.font)
    }
    
    func testLabelSetTitleColor() {
        // given
        let alpha = CGFloat.random(in: 0...1)
        let color = DesignSystem.Color.neutral100
        let label = UILabel()
        
        // when
        label.setTextColor(to: color, alpha: alpha)
        
        // than
        XCTAssertEqual(label.textColor, color.value.withAlphaComponent(alpha))
    }
    
    // MAKR: String
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
