//
//  DesignSystem.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum DesignSystem {
    /// Design system colors
    public enum Color {
        /// Neutral colors
        case white
        case neutral100
        case neutral200
        case neutral300
        case neutral400
        case neutral500
        case neutral600
        case neutral700
        case neutral800
        case neutral900
        /// Primary colors
        case primary200
        case primary400
        /// Secondary colors
        case secondary200
        case secondary400
        /// Semantic colors
        case success
        case warning
        case error

        public var value: UIColor {
            switch self {
            case .white:         return R.color.colorGuide.neutral.white()!
            case .neutral100:    return R.color.colorGuide.neutral.neutral100()!
            case .neutral200:    return R.color.colorGuide.neutral.neutral200()!
            case .neutral300:    return R.color.colorGuide.neutral.neutral300()!
            case .neutral400:    return R.color.colorGuide.neutral.neutral400()!
            case .neutral500:    return R.color.colorGuide.neutral.neutral500()!
            case .neutral600:    return R.color.colorGuide.neutral.neutral600()!
            case .neutral700:    return R.color.colorGuide.neutral.neutral700()!
            case .neutral800:    return R.color.colorGuide.neutral.neutral800()!
            case .neutral900:    return R.color.colorGuide.neutral.neutral900()!

            case  .primary200:   return R.color.colorGuide.primary.primary200()!
            case  .primary400:   return R.color.colorGuide.primary.primary400()!

            case  .secondary200: return R.color.colorGuide.secondary.secondary200()!
            case  .secondary400: return R.color.colorGuide.secondary.secondary400()!

            case  .success:      return R.color.colorGuide.semantic.success()!
            case  .warning:      return R.color.colorGuide.semantic.warning()!
            case  .error:        return R.color.colorGuide.semantic.error()!
            }
        }
    }

    /// Design system typography
    public enum Typography {
        @Inject public static var languageStorage: LanguageStorage

        public enum FontCase: CaseIterable {
            case lower, upper
        }

        case h1(fontCase: FontCase)
        case h2(fontCase: FontCase)
        case h3(fontCase: FontCase)
        case h4(fontCase: FontCase)
        case h5(fontCase: FontCase)
        case body1
        case body2
        case p

        /// Concrete description for each case
        public var description: Description {
            switch self {
            case .h1:    return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0.7, lineHeight: 44)
            case .h2:    return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0.7, lineHeight: 36)
            case .h3:    return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0.5, lineHeight: 24)
            case .h4:    return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0.3, lineHeight: 24)
            case .h5:    return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0.5, lineHeight: 16)
            case .body1: return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0, lineHeight: 20)
            case .body2: return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0, lineHeight: 16)
            case .p:     return Description(font: font(by: Typography.languageStorage.currentLanguage), lineSpasing: 0, lineHeight: 20)
            }
        }

        public func font(by language: Language) -> UIFont {
            func font(by language: Language, fontCase: FontCase, pointSize: CGFloat) -> UIFont {
                switch language {
                case .georgian: return fontCase == .lower ? R.font.pantonNusx3Bold(size: pointSize)! : R.font.pantonMtav3Bold(size: pointSize)!
                case .armenian: return R.font.pantonAMBold(size: pointSize)!
                case .english: return R.font.pantonMtav3Bold(size: pointSize)!
                }
            }

            switch self {
            case .h1(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 28)
            case .h2(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 23)
            case .h3(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 16)
            case .h4(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 14)
            case .h5(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 11)
            case .body1: return R.font.firaGOMedium(size: 13)!
            case .body2: return R.font.firaGOMedium(size: 11)!
            case .p:     return R.font.firaGORegular(size: 13)!
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

    /// Buttons
    public enum Button {
        public enum Size: CaseIterable {
            case large
            case medium
            case small
            case xs

            /// Concrete description for each case
            public var description: Description {
                switch self {
                case .large:  return Description(typograhy: .h3(fontCase: .upper), contentEdgeInsets: .init(top: 14, left: 20, bottom: 10, right: 20))
                case .medium: return Description(typograhy: .h4(fontCase: .upper), contentEdgeInsets: .init(top: 11, left: 20, bottom: 9, right: 20))
                case .small:  return Description(typograhy: .h5(fontCase: .upper), contentEdgeInsets: .init(top: 9, left: 16, bottom: 7, right: 16))
                case .xs:     return Description(typograhy: .h5(fontCase: .upper), contentEdgeInsets: .init(top: 7, left: 12, bottom: 5, right: 12))
                }
            }

            /// Availbe information about concrete button size
            public struct Description {
                public let typograhy: Typography
                public let contentEdgeInsets: UIEdgeInsets
            }
        }

        public enum Style {
            case primary(state: State)
            case secondary(state: State)
            case tertiary(state: State)
            case outline(state: State)
            case ghost(state: State)

            public var description: Description {
                switch self {
                case .primary(let state):
                    switch state {
                    case .normal:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .primary400))
                    case .hovered:
                        return Description(
                            textColor: .init(color: .neutral100, alpha: 0.8),
                            backgorundColor: .init(color: .primary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.2))
                    case .acvite:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .primary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.3))
                    case .focused:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .primary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    case .disabled:
                        return Description(
                            textColor: .init(color: .white, alpha: 0.4),
                            backgorundColor: .init(color: .primary400),
                            backgorundOverlayColor: .init(color: .neutral600, alpha: 0.5))
                    case .loading:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .primary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    }
                case .secondary(let state):
                    switch state {
                    case .normal:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .neutral500))
                    case .hovered:
                        return Description(
                            textColor: .init(color: .neutral100, alpha: 0.8),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.2))
                    case .acvite:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.3))
                    case .focused:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    case .disabled:
                        return Description(
                            textColor: .init(color: .white, alpha: 0.4),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral600, alpha: 0.9))
                    case .loading:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    }
                case .tertiary(let state):
                    switch state {
                    case .normal:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .secondary400))
                    case .hovered:
                        return Description(
                            textColor: .init(color: .neutral100, alpha: 0.8),
                            backgorundColor: .init(color: .secondary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.2))
                    case .acvite:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .secondary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.3))
                    case .focused:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .secondary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    case .disabled:
                        return Description(
                            textColor: .init(color: .white, alpha: 0.4),
                            backgorundColor: .init(color: .secondary400),
                            backgorundOverlayColor: .init(color: .neutral600, alpha: 0.5))
                    case .loading:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .secondary400),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    }
                case .outline(let state):
                    switch state {
                    case .normal:
                        return Description(
                            textColor: .init(color: .white),
                            borderColor: .init(color: .white))
                    case .hovered:
                        return Description(
                            textColor: .init(color: .neutral100, alpha: 0.8),
                            borderColor: .init(color: .white, alpha: 0.8))
                    case .acvite:
                        return Description(
                            textColor: .init(color: .white),
                            borderColor: .init(color: .white, alpha: 0.8))
                    case .focused:
                        return Description(
                            textColor: .init(color: .white),
                            borderColor: .init(color: .white, alpha: 0.8))
                    case .disabled:
                        return Description(
                            textColor: .init(color: .white, alpha: 0.4),
                            borderColor: .init(color: .white, alpha: 0.5))
                    case .loading:
                        return Description(
                            textColor: .init(color: .white),
                            borderColor: .init(color: .white))
                    }
                case .ghost(let state):
                    switch state {
                    case .normal:
                        return Description(
                            textColor: .init(color: .white))
                    case .hovered:
                        return Description(
                            textColor: .init(color: .neutral100, alpha: 0.8),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.2))
                    case .acvite:
                        return Description(
                            textColor: .init(color: .white))
                    case .focused:
                        return Description(
                            textColor: .init(color: .neutral100, alpha: 0.8),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    case .disabled:
                        return Description(
                            textColor: .init(color: .white, alpha: 0.4))
                    case .loading:
                        return Description(
                            textColor: .init(color: .white),
                            backgorundColor: .init(color: .neutral500),
                            backgorundOverlayColor: .init(color: .neutral900, alpha: 0.4))
                    }
                }
            }

            /// Availbe information about concrete button state
            public struct Description {
                public var textColor: ColorWishAlpha
                public var backgorundColor: ColorWishAlpha?
                public var backgorundOverlayColor: ColorWishAlpha?
                public var borderColor: ColorWishAlpha?
                public var borderWidth: CGFloat = 1
                public var cornerRadius: CGFloat = 4

                public var blended: UIColor? { backgorundColor?.add(color: backgorundOverlayColor) }

                public struct ColorWishAlpha {
                    public var color: Color
                    public var alpha: CGFloat = 1

                    public var caclulated: UIColor { color.value.withAlphaComponent(alpha) }
                }
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

extension DesignSystem.Button.Style.Description.ColorWishAlpha {
    func add(color: DesignSystem.Button.Style.Description.ColorWishAlpha?) -> UIColor {
        guard let color = color else {return self.color.value.withAlphaComponent(alpha)}
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        self.caclulated.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.caclulated.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        // add the components, but don't let them go above 1.0
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }
}
