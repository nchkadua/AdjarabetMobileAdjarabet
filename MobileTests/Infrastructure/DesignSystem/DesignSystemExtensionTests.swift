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
        let color = DesignSystem.Color.separator(alpha: alpha)
        let button = UIButton()
        
        // when
        button.setTitleColor(to: color, for: .normal)
        
        // than
        XCTAssertEqual(button.titleColor(for: .normal), color.value)
    }
    
    func testButtonSetStyle() {
        // given
        let state = DesignSystem.Button.State.allCases.randomElement()!
        let size = DesignSystem.Button.Size.allCases.randomElement()!
        let style = DesignSystem.Button.Style.primary(state: state, size: size)
        let button = AppCircularButton()
        
        // when
        button.setStyle(to: style)
        
        // than
        XCTAssertEqual(button.titleLabel?.font, style.description.typograhy.description.font)
        XCTAssertEqual(button.contentEdgeInsets, style.description.contentEdgeInsets)
        XCTAssertEqual(button.titleColor(for: .normal), style.description.textColor.value)
//        XCTAssertEqual(button.backgroundColor, style.description.blended)
        XCTAssertEqual(button.borderWidth, style.description.borderWidth)
        XCTAssertEqual(button.borderColor, style.description.borderColor?.value ?? .clear)
        XCTAssertEqual(button.cornerRadius, style.description.cornerRadius)
    }
    
    // MAKR: UIView
    func testViewSetBackgorundColor() {
        // given
        let color = DesignSystem.Color.separator()
        let view = UIView()
        
        // when
        view.setBackgorundColor(to: color)
        
        // than
        XCTAssertEqual(view.backgroundColor, color.value)
    }
    
    func testViewSetTintColor() {
        // given
        let alpha = CGFloat.random(in: 0...1)
        let color = DesignSystem.Color.separator(alpha: alpha)
        let view = UIView()
        
        // when
        view.setTintColor(to: color)
        
        // than
        XCTAssertEqual(view.tintColor, color.value)
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
        let color = DesignSystem.Color.separator(alpha: alpha)
        let label = UILabel()
        
        // when
        label.setTextColor(to: color)
        
        // than
        XCTAssertEqual(label.textColor, color.value)
    }
    
    // MAKR: String
    func testAttributedString() {
        DesignSystem.Typography.FontCase.allCases.forEach { fontCase in
            // given
            let typography          = DesignSystem.Typography.h1(fontCase: fontCase)
            let alignment           = NSTextAlignment.left
            let foregroundColor     = DesignSystem.Color.separator()
            
            // when
            let attributedString    = "Text".makeAttributedString(with: typography, alignment: alignment, foregroundColor: foregroundColor)
            
            /// Retrieve attributes
            let attributes = attributedString.attributes(at: 0, effectiveRange: nil)

            /// Retrieve and test font
            if let font = attributes[.font] as? UIFont {
                XCTAssertEqual(font.fontName, typography.description.font.fontName)
                XCTAssertEqual(font.pointSize, typography.description.font.pointSize)
            }
            
            /// Retrieve and test foregroundColor
            if let color = attributes[.foregroundColor] as? UIColor {
                XCTAssertEqual(color, foregroundColor.value)
            }

            /// Retrieve and test style
            if let style = attributes[.paragraphStyle] as? NSParagraphStyle {
                XCTAssertEqual(style.lineSpacing, typography.description.lineSpasing)
                XCTAssertEqual(style.alignment, alignment)
            }
        }
    }
}
