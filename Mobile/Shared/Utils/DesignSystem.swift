//
//  DesignSystem.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum DesignSystem {
    public enum Color: Equatable, Hashable {
        /// System Tints
        case systemRed(alpha: CGFloat = 1)
        case systemOrange(alpha: CGFloat = 1)
        case systemYellow(alpha: CGFloat = 1)
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
            case .systemRed(let alpha):         return colors.systemTints.systemRed()!.withAlphaComponent(alpha)
            case .systemOrange(let alpha):      return colors.systemTints.systemOrange()!.withAlphaComponent(alpha)
            case .systemYellow(let alpha):      return colors.systemTints.systemYellow()!.withAlphaComponent(alpha)
            case .systemGreen(let alpha):       return colors.systemTints.systemGreen()!.withAlphaComponent(alpha)
            case .systemTeal(let alpha):        return colors.systemTints.systemTeal()!.withAlphaComponent(alpha)
            case .systemBlue(let alpha):        return colors.systemTints.systemBlue()!.withAlphaComponent(alpha)
            case .systemIndigo(let alpha):      return colors.systemTints.systemIndigo()!.withAlphaComponent(alpha)

            case .primaryRedDark(let alpha):        return colors.adjaraSolids.primaryRedDark()!.withAlphaComponent(alpha)
            case .primaryRedNeutral(let alpha):     return colors.adjaraSolids.primaryRedNeutral()!.withAlphaComponent(alpha)
            case .primaryRed(let alpha):            return colors.adjaraSolids.primaryRed()!.withAlphaComponent(alpha)
            case .primaryGreenNeutral(let alpha):   return colors.adjaraSolids.primaryGreenNeutral()!.withAlphaComponent(alpha)

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
            case heavy, bold, semiBold, regular, light
        }

        case largeTitle34(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case largeTitle32(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case title1(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case midline(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case title2(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case title3(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case headline(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case body1(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case body2(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case callout(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case subHeadline(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case footnote(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case caption1(fontCase: FontCase, fontStyle: FontStyle = .regular)
        case caption2(fontCase: FontCase, fontStyle: FontStyle = .regular)

        /// Concrete description for each case
        public var description: Description {
            let language = Typography.languageStorage.currentLanguage

            switch self {
            case .largeTitle34: return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 47)
            case .largeTitle32: return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 44)
            case .title1:       return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 39)
            case .midline:      return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 33)
            case .title2:       return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 30)
            case .title3:       return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 28)
            case .headline:     return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 25)
            case .body1:        return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 23)
            case .body2:        return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 22)
            case .callout:      return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 21)
            case .subHeadline:  return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 19)
            case .footnote:     return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 18)
            case .caption1:     return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 17)
            case .caption2:     return .init(font: font(by: language), lineSpasing: 0.0, lineHeight: 15)
            }
        }

        func font(by language: Language) -> UIFont {
            /// Fonts
            func adjaraMont(with fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch fontStyle {
                case .heavy:        return R.font.adjaraMontHeavy(size: pointSize)!
                case .bold:         return R.font.adjaraMontBold(size: pointSize)!
                case .semiBold:     return R.font.adjaraMontSemiBold(size: pointSize)!
                case .regular:      return R.font.adjaraMontRegular(size: pointSize)!
                case .light:        return R.font.adjaraMontLight(size: pointSize)!
                }
            }

            //
            func font(by language: Language, fontCase: FontCase, fontStyle: FontStyle, pointSize: CGFloat) -> UIFont {
                switch language {
                case .georgian: return adjaraMont(with: fontStyle, pointSize: pointSize)
                case .armenian: return adjaraMont(with: fontStyle, pointSize: pointSize)
                case .english:  return adjaraMont(with: fontStyle, pointSize: pointSize)
                }
            }

            switch self {
            case .largeTitle34(let fontCase, let fontStyle):    return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 34)
            case .largeTitle32(let fontCase, let fontStyle):    return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 32)
            case .title1(let fontCase, let fontStyle):          return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 28)
            case .midline(let fontCase, let fontStyle):         return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 24)
            case .title2(let fontCase, let fontStyle):          return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 22)
            case .title3(let fontCase, let fontStyle):          return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 20)
            case .headline(let fontCase, let fontStyle):        return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 18)
            case .body1(let fontCase, let fontStyle):           return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 17)
            case .body2(let fontCase, let fontStyle):           return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 16)
            case .callout(let fontCase, let fontStyle):         return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 15)
            case .subHeadline(let fontCase, let fontStyle):     return font(by: language, fontCase: fontCase, fontStyle: fontStyle, pointSize: 14)
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
            case textLink(state: State, size: Size)

            /// Concrete description for each case
            public func sizeDescription(for size: Size) -> Size.Description {
                switch self {
                case .primary:
                    switch size {
                    case .large:  return .init(typograhy: .body1(fontCase: .upper, fontStyle: .semiBold), contentEdgeInsets: .init(top: 14 + 4, left: 20, bottom: 10 + 4, right: 20))
                    case .medium: return .init(typograhy: .subHeadline(fontCase: .upper), contentEdgeInsets: .init(top: 11 + 5, left: 20, bottom: 9 + 5, right: 20))
                    case .small:  return .init(typograhy: .subHeadline(fontCase: .upper), contentEdgeInsets: .init(top: 9 + 2, left: 16, bottom: 7 + 2, right: 16))
                    case .xs:     return .init(typograhy: .subHeadline(fontCase: .upper), contentEdgeInsets: .init(top: 7 + 2, left: 12, bottom: 5 + 2, right: 12))
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
                    case .active:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText(), backgorundColor: .primaryRed())
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .querternaryText(), backgorundColor: .thick(), overlayColor: .thick())
                    case .pressed: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .tertiaryText(), backgorundColor: .systemGrey5(), overlayColor: .thick())
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText(), backgorundColor: .primaryRed(), overlayColor: .primaryRed())
                    }
                case .textLink(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .active:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
                    case .pressed:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .primaryText())
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
            case active
            case disabled
            case pressed
            case loading
        }
    }

    public enum View {
        public enum Style {
            case primaryNormal
            case primaryPressed
            case secondaryNormal
            case secondaryPressed

            public struct Description: Equatable {
                public var backgorundColor: Color?
            }

            public var decsription: Description {
                switch self {
                case .primaryNormal: return .init(backgorundColor: .primaryBg())
                case .primaryPressed: return .init(backgorundColor: .secondaryBg())
                case .secondaryNormal: return .init(backgorundColor: .secondaryBg())
                case .secondaryPressed: return .init(backgorundColor: .tertiaryBg())
                }
            }
        }

        public enum State: CaseIterable {
            case normal
            case pressed
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

// MARK: Button
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

// MARK: View
public protocol ViewStyleImplementing {
    func setStyle(to style: DesignSystem.View.Style)
}

extension ABView: ViewStyleImplementing { }

public extension ViewStyleImplementing where Self: ABView {
    func setStyle(to style: DesignSystem.View.Style) {
        let description = style.decsription

        self.backgroundColor = description.backgorundColor?.value
    }
}
