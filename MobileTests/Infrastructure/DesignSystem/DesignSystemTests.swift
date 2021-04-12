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
        let colors = R.color.colorGuide.self
        let alpha = CGFloat.random(in: 0...1)
        
        /// System Tints
        XCTAssertEqual(DesignSystem.Color.systemRed(alpha: alpha).value, colors.systemTints.systemRed()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemOrange(alpha: alpha).value, colors.systemTints.systemOrange()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemOrange(alpha: alpha).value, colors.systemTints.systemOrange()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemYellow(alpha: alpha).value, colors.systemTints.systemYellow()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGreen(alpha: alpha).value, colors.systemTints.systemGreen()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemTeal(alpha: alpha).value, colors.systemTints.systemTeal()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemIndigo(alpha: alpha).value, colors.systemTints.systemIndigo()!.withAlphaComponent(alpha))
        /// AdjarabetSolids
        XCTAssertEqual(DesignSystem.Color.primaryRedDark(alpha: alpha).value, colors.adjaraSolids.primaryRedDark()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.primaryRedNeutral(alpha: alpha).value, colors.adjaraSolids.primaryRedNeutral()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.primaryRed(alpha: alpha).value, colors.adjaraSolids.primaryRed()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.primaryGreenNeutral(alpha: alpha).value, colors.adjaraSolids.primaryGreenNeutral()!.withAlphaComponent(alpha))
        /// SystemBackground
        XCTAssertEqual(DesignSystem.Color.primaryBg(alpha: alpha).value, colors.systemBackground.primary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.secondaryBg(alpha: alpha).value, colors.systemBackground.secondary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.tertiaryBg(alpha: alpha).value, colors.systemBackground.tertiary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.querternaryBg(alpha: alpha).value, colors.systemBackground.querternary()!.withAlphaComponent(alpha))
        /// SystemGrays
        XCTAssertEqual(DesignSystem.Color.systemGrey(alpha: alpha).value, colors.systemGrays.systemGrey()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGrey2(alpha: alpha).value, colors.systemGrays.systemGrey2()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGrey3(alpha: alpha).value, colors.systemGrays.systemGrey3()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGrey4(alpha: alpha).value, colors.systemGrays.systemGrey4()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGrey5(alpha: alpha).value, colors.systemGrays.systemGrey5()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGrey6(alpha: alpha).value, colors.systemGrays.systemGrey6()!.withAlphaComponent(alpha))
        /// TextColors
        XCTAssertEqual(DesignSystem.Color.primaryText(alpha: alpha).value, colors.textColors.primary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.secondaryText(alpha: alpha).value, colors.textColors.secondary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.tertiaryText(alpha: alpha).value, colors.textColors.tertiary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.querternaryText(alpha: alpha).value, colors.textColors.querternary()!.withAlphaComponent(alpha))
        /// FillColors
        XCTAssertEqual(DesignSystem.Color.primaryFill(alpha: alpha).value, colors.fillColors.primary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.secondaryFill(alpha: alpha).value, colors.fillColors.secondary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.tertiaryFill(alpha: alpha).value, colors.fillColors.tertiary()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.querternaryFill(alpha: alpha).value, colors.fillColors.querternary()!.withAlphaComponent(alpha))
        /// Separator
        XCTAssertEqual(DesignSystem.Color.opaque(alpha: alpha).value, colors.separator.opaque()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.nonOpaque(alpha: alpha).value, colors.separator.non_opaque()!.withAlphaComponent(alpha))
        /// Materials
        XCTAssertEqual(DesignSystem.Color.thick(alpha: alpha).value, colors.materials.thick()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.regular(alpha: alpha).value, colors.materials.regular()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.thin(alpha: alpha).value, colors.materials.thin()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.ultrathin(alpha: alpha).value, colors.materials.ultrathin()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.navBar(alpha: alpha).value, colors.materials.navBar()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.tabBar(alpha: alpha).value, colors.materials.tabBar()!.withAlphaComponent(alpha))
    }

    func testTypography() {
        Language.allCases.forEach { language in
            DefaultLanguageStorage.shared.update(language: language)
            
            var upperHeaderFontName: String!
            var lowerHeaderFontName: String!
            
            switch language {
            case .georgian:
                upperHeaderFontName = R.font.adjaraMontRegular.fontName
                lowerHeaderFontName = R.font.adjaraMontRegular.fontName
            case .armenian:
                upperHeaderFontName = R.font.adjaraMontRegular.fontName
                lowerHeaderFontName = R.font.adjaraMontRegular.fontName
            case .english:
                upperHeaderFontName = R.font.adjaraMontRegular.fontName
                lowerHeaderFontName = R.font.adjaraMontRegular.fontName
            }
            
            func testDescription(typography: DesignSystem.Typography, pointSize: CGFloat, lineSpasing: CGFloat, lineHeight: CGFloat) {
                XCTAssertEqual(typography.description.font.pointSize, pointSize)
                XCTAssertEqual(typography.description.lineSpasing, lineSpasing)
                XCTAssertEqual(typography.description.lineHeight, lineHeight)
            }

            XCTAssertEqual(DesignSystem.Typography.largeTitle34(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.largeTitle34(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .largeTitle34(fontCase: .lower), pointSize: 34, lineSpasing: 0.0, lineHeight: 47)
            testDescription(typography: .largeTitle34(fontCase: .upper), pointSize: 34, lineSpasing: 0.0, lineHeight: 47)
            
            XCTAssertEqual(DesignSystem.Typography.largeTitle32(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.largeTitle32(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .largeTitle32(fontCase: .lower), pointSize: 32, lineSpasing: 0.0, lineHeight: 44)
            testDescription(typography: .largeTitle32(fontCase: .upper), pointSize: 32, lineSpasing: 0.0, lineHeight: 44)
            
            XCTAssertEqual(DesignSystem.Typography.title1(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.title1(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .title1(fontCase: .lower), pointSize: 28, lineSpasing: 0.0, lineHeight: 39)
            testDescription(typography: .title1(fontCase: .upper), pointSize: 28, lineSpasing: 0.0, lineHeight: 39)
            
            XCTAssertEqual(DesignSystem.Typography.midline(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.midline(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .midline(fontCase: .lower), pointSize: 24, lineSpasing: 0.0, lineHeight: 33)
            testDescription(typography: .midline(fontCase: .upper), pointSize: 24, lineSpasing: 0.0, lineHeight: 33)
            
            XCTAssertEqual(DesignSystem.Typography.title2(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.title2(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .title2(fontCase: .lower), pointSize: 22, lineSpasing: 0.0, lineHeight: 30)
            testDescription(typography: .title2(fontCase: .upper), pointSize: 22, lineSpasing: 0.0, lineHeight: 30)
            
            XCTAssertEqual(DesignSystem.Typography.title3(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.title3(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .title3(fontCase: .lower), pointSize: 20, lineSpasing: 0.0, lineHeight: 28)
            testDescription(typography: .title3(fontCase: .upper), pointSize: 20, lineSpasing: 0.0, lineHeight: 28)
            
            XCTAssertEqual(DesignSystem.Typography.headline(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.headline(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .headline(fontCase: .lower), pointSize: 18, lineSpasing: 0.0, lineHeight: 25)
            testDescription(typography: .headline(fontCase: .upper), pointSize: 18, lineSpasing: 0.0, lineHeight: 25)
            
            XCTAssertEqual(DesignSystem.Typography.body1(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.body1(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .body1(fontCase: .lower), pointSize: 17, lineSpasing: 0.0, lineHeight: 23)
            testDescription(typography: .body1(fontCase: .upper), pointSize: 17, lineSpasing: 0.0, lineHeight: 23)
            
            XCTAssertEqual(DesignSystem.Typography.body2(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.body2(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .body2(fontCase: .lower), pointSize: 16, lineSpasing: 0.0, lineHeight: 22)
            testDescription(typography: .body2(fontCase: .upper), pointSize: 16, lineSpasing: 0.0, lineHeight: 22)
            
            XCTAssertEqual(DesignSystem.Typography.callout(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.callout(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .callout(fontCase: .lower), pointSize: 15, lineSpasing: 0.0, lineHeight: 21)
            testDescription(typography: .callout(fontCase: .upper), pointSize: 15, lineSpasing: 0.0, lineHeight: 21)
            
            XCTAssertEqual(DesignSystem.Typography.subHeadline(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.subHeadline(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .subHeadline(fontCase: .lower), pointSize: 14, lineSpasing: 0.0, lineHeight: 19)
            testDescription(typography: .subHeadline(fontCase: .upper), pointSize: 14, lineSpasing: 0.0, lineHeight: 19)
            
            XCTAssertEqual(DesignSystem.Typography.footnote(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.footnote(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .footnote(fontCase: .lower), pointSize: 13, lineSpasing: 0.0, lineHeight: 18)
            testDescription(typography: .footnote(fontCase: .upper), pointSize: 13, lineSpasing: 0.0, lineHeight: 18)
            
            XCTAssertEqual(DesignSystem.Typography.caption1(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.caption1(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .caption1(fontCase: .lower), pointSize: 12, lineSpasing: 0.0, lineHeight: 17)
            testDescription(typography: .caption1(fontCase: .upper), pointSize: 12, lineSpasing: 0.0, lineHeight: 17)
            
            XCTAssertEqual(DesignSystem.Typography.caption2(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.caption2(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .caption2(fontCase: .lower), pointSize: 11, lineSpasing: 0.0, lineHeight: 15)
            testDescription(typography: .caption2(fontCase: .upper), pointSize: 11, lineSpasing: 0.0, lineHeight: 15)
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
        func testPrimary(state: DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.primary(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .active:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .primaryText(),
                    backgorundColor: .primaryRed()
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .querternaryText(),
                    backgorundColor: .thick(),
                    overlayColor: .thick()
                ))
            case .pressed:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .tertiaryText(),
                    backgorundColor: .systemGrey5(),
                    overlayColor: .thick()
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .primaryText(),
                    backgorundColor: .primaryRed(),
                    overlayColor: .primaryRed()
                ))
            }
        }
        
        /// text link
        func testTextLink(state: DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.textLink(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .active:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .primaryText()))
            case .disabled:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .primaryText()))
            case .pressed:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .primaryText()))
            case .loading:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .primaryText()))
            }
        }
        
        DesignSystem.Button.State.allCases.forEach { state in
            DesignSystem.Button.Size.allCases.forEach { size in
                testPrimary(state: state, size: size)
                testTextLink(state: state, size: size)
            }
        }
    }
}
