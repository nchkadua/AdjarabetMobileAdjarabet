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
        // given
        let alpha = CGFloat.random(in: 0...1)

        /// Neutral colors
        XCTAssertEqual(DesignSystem.Color.white(alpha: alpha).value, R.color.colorGuide.neutral.white()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral100(alpha: alpha).value, R.color.colorGuide.neutral.neutral100()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral200(alpha: alpha).value, R.color.colorGuide.neutral.neutral200()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral300(alpha: alpha).value, R.color.colorGuide.neutral.neutral300()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral400(alpha: alpha).value, R.color.colorGuide.neutral.neutral400()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral500(alpha: alpha).value, R.color.colorGuide.neutral.neutral500()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral600(alpha: alpha).value, R.color.colorGuide.neutral.neutral600()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral700(alpha: alpha).value, R.color.colorGuide.neutral.neutral700()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral800(alpha: alpha).value, R.color.colorGuide.neutral.neutral800()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.neutral900(alpha: alpha).value, R.color.colorGuide.neutral.neutral900()!.withAlphaComponent(alpha))

        /// Primary colors
        XCTAssertEqual(DesignSystem.Color.primary200(alpha: alpha).value, R.color.colorGuide.primary.primary200()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.primary400(alpha: alpha).value, R.color.colorGuide.primary.primary400()!.withAlphaComponent(alpha))

        /// Secondary colors
        XCTAssertEqual(DesignSystem.Color.secondary200(alpha: alpha).value, R.color.colorGuide.secondary.secondary200()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.secondary400(alpha: alpha).value, R.color.colorGuide.secondary.secondary400()!.withAlphaComponent(alpha))

        /// Semantic colors
        XCTAssertEqual(DesignSystem.Color.success(alpha: alpha).value, R.color.colorGuide.semantic.success()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.warning(alpha: alpha).value, R.color.colorGuide.semantic.warning()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.error(alpha: alpha).value, R.color.colorGuide.semantic.error()!.withAlphaComponent(alpha))
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
    
    func testButtonStyle() {
        /// primary
        func testPrimary(state:  DesignSystem.Button.State) {
            let description = DesignSystem.Button.Style.primary(state: state).description
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .primary400()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    textColor: .neutral100(alpha: 0.8),
                    backgorundColor: .primary400(),
                    overlayColor: .neutral900(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .primary400(),
                    overlayColor: .neutral900(alpha: 0.3)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .primary400(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    textColor: .white(alpha: 0.4),
                    backgorundColor: .primary400(),
                    overlayColor: .neutral600(alpha: 0.5)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .primary400(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            }
        }
        
        /// secondary
        func testSecondary(state:  DesignSystem.Button.State) {
            let description = DesignSystem.Button.Style.secondary(state: state).description
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .neutral500()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    textColor: .neutral100(alpha: 0.8),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral900(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral900(alpha: 0.3)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    textColor: .white(alpha: 0.4),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral600(alpha: 0.9)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            }
        }
        
        /// tertiary
        func testTertiary(state:  DesignSystem.Button.State) {
            let description = DesignSystem.Button.Style.tertiary(state: state).description
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .secondary400()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    textColor: .neutral100(alpha: 0.8),
                    backgorundColor: .secondary400(),
                    overlayColor: .neutral900(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .secondary400(),
                    overlayColor: .neutral900(alpha: 0.3)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .secondary400(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    textColor: .white(alpha: 0.4),
                    backgorundColor: .secondary400(),
                    overlayColor: .neutral600(alpha: 0.5)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .secondary400(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            }
        }
        
        /// outline
        func testOutline(state:  DesignSystem.Button.State) {
            let description = DesignSystem.Button.Style.outline(state: state).description
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    borderColor: .white()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    textColor: .neutral100(alpha: 0.8),
                    borderColor: .white(alpha: 0.8)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    borderColor: .white(alpha: 0.8)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    borderColor: .white(alpha: 0.8)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    textColor: .white(alpha: 0.4),
                    borderColor: .white(alpha: 0.5)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    borderColor: .white()
                ))
            }
        }
        
        /// ghost
        func testGhost(state:  DesignSystem.Button.State) {
            let description = DesignSystem.Button.Style.ghost(state: state).description
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(textColor: .white()))
            case .hovered:
                XCTAssertEqual(description, .init(
                    textColor: .neutral100(alpha: 0.8),
                    backgorundColor: .neutral500(alpha: 0.8),
                    overlayColor: .neutral900(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(textColor: .white()))
            case .focused:
                XCTAssertEqual(description, .init(
                    textColor: .neutral100(alpha: 0.8),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(textColor: .white(alpha: 0.4)))
            case .loading:
                XCTAssertEqual(description, .init(
                    textColor: .white(),
                    backgorundColor: .neutral500(),
                    overlayColor: .neutral900(alpha: 0.4)
                ))
            }
        }
        
        DesignSystem.Button.State.allCases.forEach { state in
            testPrimary(state: state)
            testPrimary(state: state)
            testTertiary(state: state)
            testOutline(state: state)
            testGhost(state: state)
        }
    }
}
