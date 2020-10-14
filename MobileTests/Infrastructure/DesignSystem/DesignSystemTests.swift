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
        
        /// Global colors
        XCTAssertEqual(DesignSystem.Color.systemWhite(alpha: alpha).value, colors.global.systemWhite()!.withAlphaComponent(alpha))
        
        XCTAssertEqual(DesignSystem.Color.baseBg100(alpha: alpha).value, colors.global.baseBg100()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.baseBg150(alpha: alpha).value, colors.global.baseBg150()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.baseBg300(alpha: alpha).value, colors.global.baseBg300()!.withAlphaComponent(alpha))
        
        XCTAssertEqual(DesignSystem.Color.fill50(alpha: alpha).value, colors.global.fill50()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.fill110(alpha: alpha).value, colors.global.fill110()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.fill140(alpha: alpha).value, colors.global.fill140()!.withAlphaComponent(alpha))
        
        XCTAssertEqual(DesignSystem.Color.separator(alpha: alpha).value, colors.global.separator()!.withAlphaComponent(alpha))
        
        XCTAssertEqual(DesignSystem.Color.systemGray100(alpha: alpha).value, colors.global.systemGray100()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGray200(alpha: alpha).value, colors.global.systemGray200()!.withAlphaComponent(alpha))
        
        /// Semantic colors
        XCTAssertEqual(DesignSystem.Color.systemGreen100(alpha: alpha).value, colors.semantic.systemGreen100()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGreen150(alpha: alpha).value, colors.semantic.systemGreen150()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemGreen300(alpha: alpha).value, colors.semantic.systemGreen300()!.withAlphaComponent(alpha))
        
        XCTAssertEqual(DesignSystem.Color.systemRed100(alpha: alpha).value, colors.semantic.systemRed100()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemRed150(alpha: alpha).value, colors.semantic.systemRed150()!.withAlphaComponent(alpha))
        XCTAssertEqual(DesignSystem.Color.systemRed300(alpha: alpha).value, colors.semantic.systemRed300()!.withAlphaComponent(alpha))
        
        XCTAssertEqual(DesignSystem.Color.systemYellow(alpha: alpha).value, colors.semantic.systemYellow()!.withAlphaComponent(alpha))
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
            testDescription(typography: .h1(fontCase: .lower), pointSize: 23, lineSpasing: 0.0, lineHeight: 24)
            testDescription(typography: .h1(fontCase: .upper), pointSize: 23, lineSpasing: 0.0, lineHeight: 24)

            XCTAssertEqual(DesignSystem.Typography.h2(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h2(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h2(fontCase: .lower), pointSize: 18, lineSpasing: 0.2, lineHeight: 22)
            testDescription(typography: .h2(fontCase: .upper), pointSize: 18, lineSpasing: 0.2, lineHeight: 22)

            XCTAssertEqual(DesignSystem.Typography.h3(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h3(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h3(fontCase: .lower), pointSize: 16, lineSpasing: 0.3, lineHeight: 19)
            testDescription(typography: .h3(fontCase: .upper), pointSize: 16, lineSpasing: 0.3, lineHeight: 19)

            XCTAssertEqual(DesignSystem.Typography.h4(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h4(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h4(fontCase: .lower), pointSize: 13, lineSpasing: 0.5, lineHeight: 26)
            testDescription(typography: .h4(fontCase: .upper), pointSize: 13, lineSpasing: 0.5, lineHeight: 26)

            XCTAssertEqual(DesignSystem.Typography.h5(fontCase: .lower).description.font.fontName, lowerHeaderFontName)
            XCTAssertEqual(DesignSystem.Typography.h5(fontCase: .upper).description.font.fontName, upperHeaderFontName)
            testDescription(typography: .h5(fontCase: .lower), pointSize: 11, lineSpasing: 0.3, lineHeight: 14)
            testDescription(typography: .h5(fontCase: .upper), pointSize: 11, lineSpasing: 0.3, lineHeight: 14)
            
            XCTAssertEqual(DesignSystem.Typography.h6(fontCase: .lower).description.font.fontName, R.font.pantonNusx3Regular.fontName)
            XCTAssertEqual(DesignSystem.Typography.h6(fontCase: .upper).description.font.fontName, R.font.pantonNusx3Regular.fontName)
            testDescription(typography: .h6(fontCase: .lower), pointSize: 11, lineSpasing: 0.1, lineHeight: 14)
            testDescription(typography: .h6(fontCase: .upper), pointSize: 11, lineSpasing: 0.1, lineHeight: 14)
            
            let body1Description = DesignSystem.Typography.body1.description
            XCTAssertEqual(body1Description.font.fontName, R.font.firaGOMedium.fontName)
            XCTAssertEqual(body1Description.font.pointSize, 13)
            XCTAssertEqual(body1Description.lineSpasing, 0)
            XCTAssertEqual(body1Description.lineHeight, 20)
            
            let body2Description = DesignSystem.Typography.body2.description
            XCTAssertEqual(body2Description.font.fontName, R.font.firaGOMedium.fontName)
            XCTAssertEqual(body2Description.font.pointSize, 11)
            XCTAssertEqual(body2Description.lineSpasing, 0)
            XCTAssertEqual(body2Description.lineHeight, 16)
            
            let pDescription = DesignSystem.Typography.p.description
            XCTAssertEqual(pDescription.font.fontName, R.font.firaGORegular.fontName)
            XCTAssertEqual(pDescription.font.pointSize, 13)
            XCTAssertEqual(pDescription.lineSpasing, 0)
            XCTAssertEqual(pDescription.lineHeight, 20)
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
            case .normal:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemGreen150()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .separator(alpha: 0.8),
                    backgorundColor: .systemGreen150(),
                    overlayColor: .baseBg300(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemGreen150(),
                    overlayColor: .baseBg300(alpha: 0.3)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemGreen150(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(alpha: 0.4),
                    backgorundColor: .fill50(),
                    overlayColor: .fill140(alpha: 0.5)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemGreen150(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            }
        }
        
        /// secondary
        func testSecondary(state: DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.secondary(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .fill110()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .separator(alpha: 0.8),
                    backgorundColor: .fill110(),
                    overlayColor: .baseBg300(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .fill110(),
                    overlayColor: .baseBg300(alpha: 0.3)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .fill110(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(alpha: 0.4),
                    backgorundColor: .fill110(),
                    overlayColor: .fill140(alpha: 0.9)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .fill110(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            }
        }

        /// tertiary
        func testTertiary(state: DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.tertiary(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemRed150()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .separator(alpha: 0.8),
                    backgorundColor: .systemRed150(),
                    overlayColor: .baseBg300(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemRed150(),
                    overlayColor: .baseBg300(alpha: 0.3)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemRed150(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(alpha: 0.4),
                    backgorundColor: .systemRed150(),
                    overlayColor: .fill140(alpha: 0.5)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .systemRed150(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            }
        }
        
        /// outline
        func testOutline(state:  DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.outline(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    borderColor: .systemWhite()
                ))
            case .hovered:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .separator(alpha: 0.8),
                    borderColor: .systemWhite(alpha: 0.8)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    borderColor: .systemWhite(alpha: 0.8)
                ))
            case .focused:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    borderColor: .systemWhite(alpha: 0.8)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(alpha: 0.4),
                    borderColor: .systemWhite(alpha: 0.5)
                ))
            case .loading:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    borderColor: .systemWhite()
                ))
            }
        }
        
        /// ghost
        func testGhost(state:  DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.ghost(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .systemWhite()))
            case .hovered:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .separator(alpha: 0.8),
                    backgorundColor: .fill110(alpha: 0.8),
                    overlayColor: .baseBg300(alpha: 0.2)
                ))
            case .acvite:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .systemWhite()))
            case .focused:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .separator(alpha: 0.8),
                    backgorundColor: .fill110(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            case .disabled:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4)))
            case .loading:
                XCTAssertEqual(description, .init(
                    typograhy: tc.typograhy,
                    contentEdgeInsets: tc.contentEdgeInsets,
                    textColor: .systemWhite(),
                    backgorundColor: .fill110(),
                    overlayColor: .baseBg300(alpha: 0.4)
                ))
            }
        }
        
        /// text link
        func testTextLink(state: DesignSystem.Button.State, size: DesignSystem.Button.Size) {
            let style = DesignSystem.Button.Style.textLink(state: state, size: size)
            let description = style.description
            let tc = style.sizeDescription(for: size)
            switch state {
            case .normal:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .separator()))
            case .hovered:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .separator(alpha: 0.8)))
            case .acvite:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .separator()))
            case .focused:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .separator()))
            case .disabled:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .separator(alpha: 0.8)))
            case .loading:
                XCTAssertEqual(description, .init(typograhy: tc.typograhy, contentEdgeInsets: tc.contentEdgeInsets, textColor: .systemWhite()))
            }
        }
        
        DesignSystem.Button.State.allCases.forEach { state in
            DesignSystem.Button.Size.allCases.forEach { size in
                testPrimary(state: state, size: size)
                testPrimary(state: state, size: size)
                testTertiary(state: state, size: size)
                testOutline(state: state, size: size)
                testGhost(state: state, size: size)
                testTextLink(state: state, size: size)
            }
        }
    }
}
