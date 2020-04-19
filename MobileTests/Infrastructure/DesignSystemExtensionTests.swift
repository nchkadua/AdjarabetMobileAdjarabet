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
        let color = DesignSystem.Color.neutral100
        let button = UIButton()
        
        // when
        button.setTitleColor(to: color, for: .normal)
        
        // than
        XCTAssertEqual(button.titleColor(for: .normal), color.value)
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
        let color = DesignSystem.Color.neutral100
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
        let color = DesignSystem.Color.neutral100
        let label = UILabel()
        
        // when
        label.setTextColor(to: color)
        
        // than
        XCTAssertEqual(label.textColor, color.value)
    }
}
