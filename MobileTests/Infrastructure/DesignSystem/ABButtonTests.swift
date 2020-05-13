//
//  ABButtonTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 5/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class ABButtonTests: XCTestCase {
    func testButtonSetStyle() {
        // given
        let style = DesignSystem.Button.Style.primary(state: DesignSystem.Button.State.allCases.randomElement()!)
        let button = ABButton()
        
        // when
        button.setStyle(to: style)
        
        // than
        test(button: button, style: style)
    }
    
    private func test(button: ABButton, style: DesignSystem.Button.Style) {
        XCTAssertEqual(button.titleColor(for: .normal), style.description.textColor.value)
        XCTAssertEqual(button.backgroundColor, style.description.blended)
        XCTAssertEqual(button.borderWidth, style.description.borderWidth)
        XCTAssertEqual(button.borderColor, style.description.borderColor?.value ?? .clear)
        XCTAssertEqual(button.cornerRadius, style.description.cornerRadius)
    }
}
