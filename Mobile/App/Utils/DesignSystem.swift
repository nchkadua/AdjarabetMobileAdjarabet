//
//  DesignSystem.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum DesignSystem {
    public enum Color: Equatable, Hashable {
        /// Global colors
        case systemWhite(alpha: CGFloat = 1)
        case baseBg100(alpha: CGFloat = 1)
        case baseBg150(alpha: CGFloat = 1)
        case baseBg300(alpha: CGFloat = 1)
        case fill50(alpha: CGFloat = 0.18)
        case fill110(alpha: CGFloat = 0.32)
        case fill140(alpha: CGFloat = 0.36)
        case separator(alpha: CGFloat = 0.3)
        case systemGray100(alpha: CGFloat = 1)
        case systemGray200(alpha: CGFloat = 1)
        /// Semantic colors
        case systemGreen100(alpha: CGFloat = 1)
        case systemGreen150(alpha: CGFloat = 1)
        case systemGreen300(alpha: CGFloat = 1)
        case systemRed100(alpha: CGFloat = 1)
        case systemRed150(alpha: CGFloat = 1)
        case systemRed300(alpha: CGFloat = 1)
        case systemYellow(alpha: CGFloat = 1)
        // Delete colors above
        /// System Tints
        case systemRed(alpha: CGFloat = 1)
        case systemOrange(alpha: CGFloat = 1)
        //case systemYellow(alpha: CGFloat = 1) use after deleting old colors
        case systemGreen(alpha: CGFloat = 1)
        case systemTeal(alpha: CGFloat = 1)
        case systemBlue(alpha: CGFloat = 1)
        case systemIndigo(alpha: CGFloat = 1)
        /// AdjarabetSolids
        case primaryRedDark(alpha: CGFloat = 1)
        case primaryRedNeutral(alpha: CGFloat = 1)
        case primaryRed(alpha: CGFloat = 1)
        case primaryGreenNeutral(alpha: CGFloat = 1)
        /// SystemBackground
        case primaryBg(alpha: CGFloat = 1)
        case secondaryBg(alpha: CGFloat = 1)
        case tertiaryBg(alpha: CGFloat = 1)
        case querternaryBg(alpha: CGFloat = 1)
        /// SystemGrays
        case systemGrey(alpha: CGFloat = 1)
        case systemGrey2(alpha: CGFloat = 1)
        case systemGrey3(alpha: CGFloat = 1)
        case systemGrey4(alpha: CGFloat = 1)
        case systemGrey5(alpha: CGFloat = 1)
        case systemGrey6(alpha: CGFloat = 1)
        /// TextColors
        case primaryText(alpha: CGFloat = 1)
        case secondaryText(alpha: CGFloat = 0.6)
        case tertiaryText(alpha: CGFloat = 0.3)
        case querternaryText(alpha: CGFloat = 0.18)
        /// FillColors
        case primaryFill(alpha: CGFloat = 0.36)
        case secondaryFill(alpha: CGFloat = 0.32)
        case tertiaryFill(alpha: CGFloat = 0.24)
        case querternaryFill(alpha: CGFloat = 0.18)
        /// Separator
        case opaque(alpha: CGFloat = 1)
        case nonOpaque(alpha: CGFloat = 0.65)
        /// Materials
        case thick(alpha: CGFloat = 0.85)
        case regular(alpha: CGFloat = 0.7)
        case thin(alpha: CGFloat = 0.65)
        case ultrathin(alpha: CGFloat = 0.45)
        case navBar(alpha: CGFloat = 0.8)
        case tabBar(alpha: CGFloat = 0.8)

        public var value: UIColor {
            let colors = R.color.colorGuide.self

            switch self {
            case .systemWhite(let alpha):              return colors.global.systemWhite()!.withAlphaComponent(alpha)
            case .baseBg100(alpha: let alpha):      return colors.global.baseBg100()!.withAlphaComponent(alpha)
            case .baseBg150(alpha: let alpha):      return colors.global.baseBg150()!.withAlphaComponent(alpha)
            case .baseBg300(alpha: let alpha):      return colors.global.baseBg300()!.withAlphaComponent(alpha)
            case .fill50(alpha: let alpha):         return colors.global.fill50()!.withAlphaComponent(alpha)
            case .fill110(alpha: let alpha):        return colors.global.fill110()!.withAlphaComponent(alpha)
            case .fill140(alpha: let alpha):        return colors.global.fill140()!.withAlphaComponent(alpha)
            case .separator(alpha: let alpha):      return colors.global.separator()!.withAlphaComponent(alpha)
            case .systemGray100(alpha: let alpha):     return colors.global.systemGray100()!.withAlphaComponent(alpha)
            case .systemGray200(alpha: let alpha):     return colors.global.systemGray200()!.withAlphaComponent(alpha)

            case .systemGreen100(alpha: let alpha):    return colors.semantic.systemGreen100()!.withAlphaComponent(alpha)
            case .systemGreen150(alpha: let alpha):    return colors.semantic.systemGreen150()!.withAlphaComponent(alpha)
            case .systemGreen300(alpha: let alpha):    return colors.semantic.systemGreen300()!.withAlphaComponent(alpha)
            case .systemRed100(alpha: let alpha):      return colors.semantic.systemRed100()!.withAlphaComponent(alpha)
            case .systemRed150(alpha: let alpha):      return colors.semantic.systemRed150()!.withAlphaComponent(alpha)
            case .systemRed300(alpha: let alpha):      return colors.semantic.systemRed300()!.withAlphaComponent(alpha)
            case .systemYellow(alpha: let alpha):      return colors.semantic.systemYellow()!.withAlphaComponent(alpha)

            case .primaryRedDark(let alpha):        return colors.adjaraSolids.primaryRedDark()!.withAlphaComponent(alpha)
            case .primaryRedNeutral(let alpha):     return colors.adjaraSolids.primaryRedNeutral()!.withAlphaComponent(alpha)
            case .primaryRed(let alpha):            return colors.adjaraSolids.primaryRed()!.withAlphaComponent(alpha)
            case .primaryGreenNeutral(let alpha):   return colors.adjaraSolids.primaryGreenNeutral()!.withAlphaComponent(alpha)

            case .systemRed(let alpha):         return colors.systemTints.systemRed()!.withAlphaComponent(alpha)
            case .systemOrange(let alpha):      return colors.systemTints.systemOrange()!.withAlphaComponent(alpha)
            //case .systemYellow(let alpha):  return colors.systemTints.systemYellow()!.withAlphaComponent(alpha)  use after deleting old colors
            case .systemGreen(let alpha):       return colors.systemTints.systemGreen()!.withAlphaComponent(alpha)
            case .systemTeal(let alpha):        return colors.systemTints.systemTeal()!.withAlphaComponent(alpha)
            case .systemBlue(let alpha):        return colors.systemTints.systemBlue()!.withAlphaComponent(alpha)
            case .systemIndigo(let alpha):      return colors.systemTints.systemIndigo()!.withAlphaComponent(alpha)

            case .primaryBg(let alpha):         return colors.systemBackground.primary()!.withAlphaComponent(alpha)
            case .secondaryBg(let alpha):       return colors.systemBackground.secondary()!.withAlphaComponent(alpha)
            case .tertiaryBg(let alpha):        return colors.systemBackground.tertiary()!.withAlphaComponent(alpha)
            case .querternaryBg(let alpha):     return colors.systemBackground.querternary()!.withAlphaComponent(alpha)

            case .systemGrey(let alpha):        return colors.systemGrays.systemGrey()!.withAlphaComponent(alpha)
            case .systemGrey2(let alpha):       return colors.systemGrays.systemGrey2()!.withAlphaComponent(alpha)
            case .systemGrey3(let alpha):       return colors.systemGrays.systemGrey3()!.withAlphaComponent(alpha)
            case .systemGrey4(let alpha):       return colors.systemGrays.systemGrey4()!.withAlphaComponent(alpha)
            case .systemGrey5(let alpha):       return colors.systemGrays.systemGrey5()!.withAlphaComponent(alpha)
            case .systemGrey6(let alpha):       return colors.systemGrays.systemGrey6()!.withAlphaComponent(alpha)

            case .primaryText(let alpha):       return colors.textColors.primary()!.withAlphaComponent(alpha)
            case .secondaryText(let alpha):     return colors.textColors.secondary()!.withAlphaComponent(alpha)
            case .tertiaryText(let alpha):      return colors.textColors.tertiary()!.withAlphaComponent(alpha)
            case .querternaryText(let alpha):   return colors.textColors.querternary()!.withAlphaComponent(alpha)

            case .primaryFill(let alpha):       return colors.fillColors.primary()!.withAlphaComponent(alpha)
            case .secondaryFill(let alpha):     return colors.fillColors.secondary()!.withAlphaComponent(alpha)
            case .tertiaryFill(let alpha):      return colors.fillColors.tertiary()!.withAlphaComponent(alpha)
            case .querternaryFill(let alpha):   return colors.fillColors.querternary()!.withAlphaComponent(alpha)

            case .opaque(let alpha):        return colors.separator.opaque()!.withAlphaComponent(alpha)
            case .nonOpaque(let alpha):     return colors.separator.non_opaque()!.withAlphaComponent(alpha)

            case .thick(let alpha):         return colors.materials.thick()!.withAlphaComponent(alpha)
            case .regular(let alpha):       return colors.materials.regular()!.withAlphaComponent(alpha)
            case .thin(let alpha):          return colors.materials.thin()!.withAlphaComponent(alpha)
            case .ultrathin(let alpha):     return colors.materials.ultrathin()!.withAlphaComponent(alpha)
            case .navBar(let alpha):        return colors.materials.navBar()!.withAlphaComponent(alpha)
            case .tabBar(let alpha):        return colors.materials.tabBar()!.withAlphaComponent(alpha)
            }
        }
    }

    /// Design system typography
    public enum Typography: Equatable {
        @Inject public static var languageStorage: LanguageStorage

        public enum FontCase: CaseIterable {
            case lower, upper
        }

        public enum FontStyle: CaseIterable {
            case regular, medium, bold, semiBold
        }

        case h1(fontCase: FontCase)
        case h2(fontCase: FontCase)
        case h3(fontCase: FontCase)
        case h4(fontCase: FontCase)
        case h5(fontCase: FontCase)
        case h6(fontCase: FontCase)
        case body1
        case body2
        case p
        // Delete fonts above
        case largeTitle(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case title1(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case title2(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case title3(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case headline(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case body(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case callout(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case subHeadline(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case footnote(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case caption1(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case caption2(fontCase: FontCase, fontStyle: FontStyle = .regular)

        /// Concrete description for each case
        public var description: Description {
            let language = Typography.languageStorage.currentLanguage

            switch self {
            case .h1:    return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 24)
            case .h2:    return .init(font: font(by: language), lineSpasing: 0.2, lineHeight: 22)
            case .h3:    return .init(font: font(by: language), lineSpasing: 0.3, lineHeight: 19)
            case .h4:    return .init(font: font(by: language), lineSpasing: 0.5, lineHeight: 26)
            case .h5:    return .init(font: font(by: language), lineSpasing: 0.3, lineHeight: 14)
            case .h6:    return .init(font: font(by: language), lineSpasing: 0.1, lineHeight: 14)
            case .body1: return .init(font: font(by: language), lineSpasing: 0, lineHeight: 20)
            case .body2: return .init(font: font(by: language), lineSpasing: 0, lineHeight: 16)
            case .p:     return .init(font: font(by: language), lineSpasing: 0, lineHeight: 20)
            // Delete fonts above
            case .largeTitle:   return .init(font: font(by: language), lineSpasing: 0.37, lineHeight: 41)
            case .title1:       return .init(font: font(by: language), lineSpasing: 0.36, lineHeight: 34)
            case .title2:       return .init(font: font(by: language), lineSpasing: 0.35, lineHeight: 28)
            case .title3:       return .init(font: font(by: language), lineSpasing: 0.38, lineHeight: 24)
            case .headline:     return .init(font: font(by: language), lineSpasing: -0.41, lineHeight: 22)
            case .body:         return .init(font: font(by: language), lineSpasing: -0.41, lineHeight: 22)
            case .callout:      return .init(font: font(by: language), lineSpasing: -0.32, lineHeight: 21)
            case .subHeadline:  return .init(font: font(by: language), lineSpasing: -0.24, lineHeight: 20)
            case .footnote:     return .init(font: font(by: language), lineSpasing: -0.08, lineHeight: 18)
            case .caption1:     return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 16)
            case .caption2:     return .init(font: font(by: language), lineSpasing: 0.07, lineHeight: 13)
            }
        }

        func font(by language: Language) -> UIFont {
            /// Fonts
            func firaGo(with fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch fontStyle {
                case .regular:      return R.font.firaGORegular(size: pointSize)!
                case .medium:       return R.font.firaGOMedium(size: pointSize)!
                case .bold:         return R.font.firaGOBold(size: pointSize)!
                case .semiBold:     return R.font.firaGOSemiBold(size: pointSize)!
                }
            }

            func notoSansArmenian(with fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch fontStyle {
                case .regular:      return R.font.notoSansArmenianRegular(size: pointSize)!
                case .medium:       return R.font.notoSansArmenianMedium(size: pointSize)!
                case .bold:         return R.font.notoSansArmenianBold(size: pointSize)!
                case .semiBold:     return R.font.notoSansArmenianBold(size: pointSize)!
                }
            }

            func pantonMtav3(with fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch fontStyle {
                case .regular:      return R.font.pantonMtav3Regular(size: pointSize)!
                case .medium:       return R.font.pantonMtav3Regular(size: pointSize)! // Same as regular
                case .bold:         return R.font.pantonMtav3Bold(size: pointSize)!
                case .semiBold:     return R.font.pantonMtav3Bold(size: pointSize)! // Same as bold
                }
            }

            func pantonAM(with fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch fontStyle {
                case .regular:      return R.font.pantonAMRegular(size: pointSize)!
                case .medium:       return R.font.pantonAMRegular(size: pointSize)! // Same as regular
                case .bold:         return R.font.pantonAMBold(size: pointSize)!
                case .semiBold:     return R.font.pantonAMBold(size: pointSize)! // Same as bold
                }
            }

            //
            func font(by language: Language, fontCase: FontCase, fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch language {
                case .georgian: return fontCase == .lower ? firaGo(with: fontStyle, pointSize: pointSize) : pantonMtav3(with: fontStyle, pointSize: pointSize)
                case .armenian: return fontCase == .lower ? notoSansArmenian(with: fontStyle, pointSize: pointSize) : pantonAM(with: fontStyle, pointSize: pointSize)
                case .english:  return fontCase == .lower ? firaGo(with: fontStyle, pointSize: pointSize) : pantonMtav3(with: fontStyle, pointSize: pointSize)
                }
            }

            switch self {
            case .h1:               return R.font.pantonNusx3Regular(size: 11)!
            case .h2:               return R.font.pantonNusx3Regular(size: 11)!
            case .h3:               return R.font.pantonNusx3Regular(size: 11)!
            case .h4:               return R.font.pantonNusx3Regular(size: 11)!
            case .h5:               return R.font.pantonNusx3Regular(size: 11)!
            case .h6:               return R.font.pantonNusx3Regular(size: 11)!
            case .body1:            return R.font.firaGOMedium(size: 13)!
            case .body2:            return R.font.firaGOMedium(size: 11)!
            case .p:                return R.font.firaGORegular(size: 13)!
            // Delete fonts above
            case .largeTitle(let fontCase, let fontStyle):      return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 34)
            case .title1(let fontCase, let fontStyle):          return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 28)
            case .title2(let fontCase, let fontStyle):          return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 22)
            case .title3(let fontCase, let fontStyle):          return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 20)
            case .headline(let fontCase, let fontStyle):        return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 17)
            case .body(let fontCase, let fontStyle):            return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 17)
            case .callout(let fontCase, let fontStyle):         return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 16)
            case .subHeadline(let fontCase, let fontStyle):     return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 15)
            case .footnote(let fontCase, let fontStyle):        return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 13)
            case .caption1(let fontCase, let fontStyle):        return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 12)
            case .caption2(let fontCase, let fontStyle):        return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 11)
            }
        }

        /// Availbe information about concrete typography
        public struct Description {
            public let font: UIFont
            public let lineSpasing: CGFloat
            public let lineHeight: CGFloat
        }
    }

    /// Design system spacing
    public enum Spacing: Int {
        case space4 = 4
        case space8 = 8
        case space12 = 12
        case space16 = 16
        case space20 = 20
        case space24 = 24
        case space28 = 28
        case space32 = 32

        public var value: Int { rawValue }
    }

    /// Input
    public enum Input {
        public static let backgroundColor: Color        = .secondaryBg()
        public static let tintColor: Color              = .primaryText()

        public static let placeholderFont: Typography   = .footnote(fontCase: .lower, fontStyle: .regular)

        public static let placeholTextColor: Color      = .secondaryText()
        public static let textFieldTextColor: Color     = .primaryText()

        public static let borderWidth: CGFloat          = 1
        public static let borderColor: Color            = .nonOpaque()
        public static let cornerRadius: CGFloat         = 4

        public enum Size: CaseIterable {
            case small
            case medium
            case large

            public var height: CGFloat {
                switch self {
                case .small:    return 32
                case .medium:   return 40
                case .large:    return 54
                }
            }

            public var textFieldHeight: CGFloat {
                switch self {
                case .small:            return 16
                case .medium, .large:   return 24
                }
            }

            public var textFieldFont: Typography {
                switch self {
                case .small:            return .subHeadline(fontCase: .lower, fontStyle: .regular)
                case .medium, .large:   return .subHeadline(fontCase: .lower, fontStyle: .regular)
                }
            }
        }
    }

    /// Buttons
    public enum Button {
        public enum Size: CaseIterable {
            case large
            case medium
            case small
            case xs

            /// Availbe information about concrete button size
            public struct Description {
                public let typograhy: Typography
                public var contentEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }

        public enum Style {
            case primary(state: State, size: Size)
            case secondary(state: State, size: Size)
            case tertiary(state: State, size: Size)
            case outline(state: State, size: Size)
            case ghost(state: State, size: Size)
            case textLink(state: State, size: Size)

            /// Concrete description for each case
            public func sizeDescription(for size: Size) -> Size.Description {
                switch self {
                case .primary, .secondary, .tertiary, .outline, .ghost:
                    var fontCase: Typography.FontCase = .upper
                    if case .ghost = self { fontCase = .lower }

                    switch size {
                    case .large:  return .init(typograhy: .subHeadline(fontCase: fontCase, fontStyle: .semiBold), contentEdgeInsets: .init(top: 14 + 4, left: 20, bottom: 10 + 4, right: 20))
                    case .medium: return .init(typograhy: .h4(fontCase: fontCase), contentEdgeInsets: .init(top: 11 + 5, left: 20, bottom: 9 + 5, right: 20))
                    case .small:  return .init(typograhy: .h5(fontCase: fontCase), contentEdgeInsets: .init(top: 9 + 2, left: 16, bottom: 7 + 2, right: 16))
                    case .xs:     return .init(typograhy: .h5(fontCase: fontCase), contentEdgeInsets: .init(top: 7 + 2, left: 12, bottom: 5 + 2, right: 12))
                    }
                case .textLink:
                    switch size {
                    case .large:  return .init(typograhy: .footnote(fontCase: .upper, fontStyle: .semiBold))
                    case .medium: return .init(typograhy: .footnote(fontCase: .upper, fontStyle: .semiBold))
                    case .small:  return .init(typograhy: .footnote(fontCase: .upper, fontStyle: .semiBold))
                    case .xs:     return .init(typograhy: .footnote(fontCase: .upper, fontStyle: .semiBold))
                    }
                }
            }

            /// Concrete description for each case
            public var description: Description {
                switch self {
                case .primary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemGreen150())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .systemGreen150(), overlayColor: .baseBg300(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemGreen150(), overlayColor: .baseBg300(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemGreen150(), overlayColor: .baseBg300(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4), backgorundColor: .fill50(), overlayColor: .fill140(alpha: 0.5))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemGreen150(), overlayColor: .baseBg300(alpha: 0.4))
                    }
                case .secondary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText(), backgorundColor: .fill110())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText(), backgorundColor: .fill110(), overlayColor: .fill140(alpha: 0.9))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4), backgorundColor: .fill110(), overlayColor: .fill140(alpha: 0.9))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.4))
                    }
                case .tertiary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemRed150())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .systemRed150(), overlayColor: .baseBg300(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText(), backgorundColor: .primaryRed(), overlayColor: .baseBg300(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemRed150(), overlayColor: .baseBg300(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText(), backgorundColor: .systemRed150(), overlayColor: .fill140(alpha: 0.5))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemRed150(), overlayColor: .baseBg300(alpha: 0.4))
                    }
                case .outline(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), borderColor: .systemWhite())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), borderColor: .systemWhite(alpha: 0.8))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), borderColor: .systemWhite(alpha: 0.8))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), borderColor: .systemWhite(alpha: 0.8))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4), borderColor: .systemWhite(alpha: 0.5))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), borderColor: .systemWhite())
                    }
                case .ghost(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .fill110(alpha: 0.8), overlayColor: .baseBg300(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite())
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.4))
                    }
                case .textLink(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .tertiaryText())
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemRed())
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
                    }
                }
            }

            /// Availbe information about concrete button state
            public struct Description: Equatable {
                public let typograhy: Typography
                public let contentEdgeInsets: UIEdgeInsets
                public var textColor: Color
                public var backgorundColor: Color?
                public var overlayColor: Color?
                public var borderColor: Color?
                public var borderWidth: CGFloat = 1
                public var cornerRadius: CGFloat = 8

                public var blended: UIColor? { backgorundColor?.add(color: overlayColor) }
            }
        }

        public enum State: CaseIterable {
            case normal
            case hovered
            case acvite
            case focused
            case disabled
            case loading
        }
    }
}

extension DesignSystem.Color {
    func add(color: DesignSystem.Color?) -> UIColor {
        guard let color = color else {return value}

        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        value.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.value.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }
}

public protocol ButtonStyleImplementing {
    func setStyle(to style: DesignSystem.Button.Style)
}

extension AppCircularButton: ButtonStyleImplementing { }

public extension ButtonStyleImplementing where Self: AppCircularButton {
    func setStyle(to style: DesignSystem.Button.Style) {
        let description = style.description

        setFont(to: description.typograhy)
        contentEdgeInsets = description.contentEdgeInsets

        setTitleColor(to: description.textColor, for: .normal)
        
        self.backgroundColor = description.backgorundColor?.value
        self.borderWidth = description.borderWidth
        self.borderColor = description.borderColor?.value ?? .clear
        self.cornerRadius = description.cornerRadius
    }
}
