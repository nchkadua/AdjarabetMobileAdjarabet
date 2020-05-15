//
//  DesignSystem.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public enum DesignSystem {
    /// Design system colors
    public enum Color: Equatable, Hashable {
        /// Neutral colors
        case white(alpha: CGFloat = 1)
        case neutral100(alpha: CGFloat = 1)
        case neutral200(alpha: CGFloat = 1)
        case neutral300(alpha: CGFloat = 1)
        case neutral400(alpha: CGFloat = 1)
        case neutral500(alpha: CGFloat = 1)
        case neutral600(alpha: CGFloat = 1)
        case neutral700(alpha: CGFloat = 1)
        case neutral800(alpha: CGFloat = 1)
        case neutral900(alpha: CGFloat = 1)
        /// Primary colors
        case primary200(alpha: CGFloat = 1)
        case primary400(alpha: CGFloat = 1)
        /// Secondary colors
        case secondary200(alpha: CGFloat = 1)
        case secondary400(alpha: CGFloat = 1)
        /// Semantic colors
        case success(alpha: CGFloat = 1)
        case warning(alpha: CGFloat = 1)
        case error(alpha: CGFloat = 1)

        public var value: UIColor {
            let colors = R.color.colorGuide.self

            switch self {
            case .white(let alpha):         return colors.neutral.white()!.withAlphaComponent(alpha)
            case .neutral100(let alpha):    return colors.neutral.neutral100()!.withAlphaComponent(alpha)
            case .neutral200(let alpha):    return colors.neutral.neutral200()!.withAlphaComponent(alpha)
            case .neutral300(let alpha):    return colors.neutral.neutral300()!.withAlphaComponent(alpha)
            case .neutral400(let alpha):    return colors.neutral.neutral400()!.withAlphaComponent(alpha)
            case .neutral500(let alpha):    return colors.neutral.neutral500()!.withAlphaComponent(alpha)
            case .neutral600(let alpha):    return colors.neutral.neutral600()!.withAlphaComponent(alpha)
            case .neutral700(let alpha):    return colors.neutral.neutral700()!.withAlphaComponent(alpha)
            case .neutral800(let alpha):    return colors.neutral.neutral800()!.withAlphaComponent(alpha)
            case .neutral900(let alpha):    return colors.neutral.neutral900()!.withAlphaComponent(alpha)

            case  .primary200(let alpha):   return colors.primary.primary200()!.withAlphaComponent(alpha)
            case  .primary400(let alpha):   return colors.primary.primary400()!.withAlphaComponent(alpha)

            case  .secondary200(let alpha): return colors.secondary.secondary200()!.withAlphaComponent(alpha)
            case  .secondary400(let alpha): return colors.secondary.secondary400()!.withAlphaComponent(alpha)

            case  .success(let alpha):      return colors.semantic.success()!.withAlphaComponent(alpha)
            case  .warning(let alpha):      return colors.semantic.warning()!.withAlphaComponent(alpha)
            case  .error(let alpha):        return colors.semantic.error()!.withAlphaComponent(alpha)
            }
        }
    }

    /// Design system typography
    public enum Typography: Equatable {
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
            let language = Typography.languageStorage.currentLanguage

            switch self {
            case .h1:    return .init(font: font(by: language), lineSpasing: 0.7, lineHeight: 44)
            case .h2:    return .init(font: font(by: language), lineSpasing: 0.7, lineHeight: 36)
            case .h3:    return .init(font: font(by: language), lineSpasing: 0.5, lineHeight: 24)
            case .h4:    return .init(font: font(by: language), lineSpasing: 0.3, lineHeight: 20)
            case .h5:    return .init(font: font(by: language), lineSpasing: 0.5, lineHeight: 16)
            case .body1: return .init(font: font(by: language), lineSpasing: 0, lineHeight: 20)
            case .body2: return .init(font: font(by: language), lineSpasing: 0, lineHeight: 16)
            case .p:     return .init(font: font(by: language), lineSpasing: 0, lineHeight: 20)
            }
        }

        public func font(by language: Language) -> UIFont {
            func font(by language: Language, fontCase: FontCase, pointSize: CGFloat) -> UIFont {
                switch language {
                case .georgian: return fontCase == .lower ? R.font.pantonNusx3Bold(size: pointSize)! : R.font.pantonMtav3Bold(size: pointSize)!
                case .armenian: return R.font.pantonAMBold(size: pointSize)!
                case .english:  return R.font.pantonMtav3Bold(size: pointSize)!
                }
            }

            switch self {
            case .h1(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 28)
            case .h2(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 23)
            case .h3(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 16)
            case .h4(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 14)
            case .h5(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 11)
            case .body1:            return R.font.firaGOMedium(size: 13)!
            case .body2:            return R.font.firaGOMedium(size: 11)!
            case .p:                return R.font.firaGORegular(size: 13)!
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
        public static let backgroundColor: Color        = .neutral600()
        public static let tintColor: Color              = .white()

        public static let placeholderFont: Typography   = .body2

        public static let placeholTextColor: Color      = .neutral100(alpha: 0.6)
        public static let textFieldTextColor: Color     = .neutral100()

        public static let borderWidth: CGFloat          = 1
        public static let borderColor: Color            = .neutral400()
        public static let cornerRadius: CGFloat         = 4

        public enum Size: CaseIterable {
            case small
            case medium
            case large

            public var height: CGFloat {
                switch self {
                case .small:    return 32
                case .medium:   return 40
                case .large:    return 48
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
                case .small:            return .h5(fontCase: .lower)
                case .medium, .large:   return .h4(fontCase: .lower)
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
                    case .large:  return .init(typograhy: .h3(fontCase: fontCase), contentEdgeInsets: .init(top: 14 + 4, left: 20, bottom: 10 + 4, right: 20))
                    case .medium: return .init(typograhy: .h4(fontCase: fontCase), contentEdgeInsets: .init(top: 11 + 5, left: 20, bottom: 9 + 5, right: 20))
                    case .small:  return .init(typograhy: .h5(fontCase: fontCase), contentEdgeInsets: .init(top: 9 + 2, left: 16, bottom: 7 + 2, right: 16))
                    case .xs:     return .init(typograhy: .h5(fontCase: fontCase), contentEdgeInsets: .init(top: 7 + 2, left: 12, bottom: 5 + 2, right: 12))
                    }
                case .textLink:
                    switch size {
                    case .large:  return .init(typograhy: .body2)
                    case .medium: return .init(typograhy: .body2)
                    case .small:  return .init(typograhy: .body2)
                    case .xs:     return .init(typograhy: .body2)
                    }
                }
            }

            /// Concrete description for each case
            public var description: Description {
                switch self {
                case .primary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .primary400())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8), backgorundColor: .primary400(), overlayColor: .neutral900(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .primary400(), overlayColor: .neutral900(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .primary400(), overlayColor: .neutral900(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(alpha: 0.4), backgorundColor: .primary400(), overlayColor: .neutral600(alpha: 0.5))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .primary400(), overlayColor: .neutral900(alpha: 0.4))
                    }
                case .secondary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .neutral500())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8), backgorundColor: .neutral500(), overlayColor: .neutral900(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .neutral500(), overlayColor: .neutral900(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .neutral500(), overlayColor: .neutral900(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(alpha: 0.4), backgorundColor: .neutral500(), overlayColor: .neutral600(alpha: 0.9))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .neutral500(), overlayColor: .neutral900(alpha: 0.4))
                    }
                case .tertiary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .secondary400())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8), backgorundColor: .secondary400(), overlayColor: .neutral900(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .secondary400(), overlayColor: .neutral900(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .secondary400(), overlayColor: .neutral900(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(alpha: 0.4), backgorundColor: .secondary400(), overlayColor: .neutral600(alpha: 0.5))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .secondary400(), overlayColor: .neutral900(alpha: 0.4))
                    }
                case .outline(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), borderColor: .white())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8), borderColor: .white(alpha: 0.8))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), borderColor: .white(alpha: 0.8))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), borderColor: .white(alpha: 0.8))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(alpha: 0.4), borderColor: .white(alpha: 0.5))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), borderColor: .white())
                    }
                case .ghost(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8), backgorundColor: .neutral500(alpha: 0.8), overlayColor: .neutral900(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white())
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8), backgorundColor: .neutral500(), overlayColor: .neutral900(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(alpha: 0.4))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white(), backgorundColor: .neutral500(), overlayColor: .neutral900(alpha: 0.4))
                    }
                case .textLink(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100())
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100())
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .neutral100(alpha: 0.8))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .white())
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
                public var cornerRadius: CGFloat = 4

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

        self.backgroundColor = description.blended
        self.borderWidth = description.borderWidth
        self.borderColor = description.borderColor?.value ?? .clear
        self.cornerRadius = description.cornerRadius
    }
}
