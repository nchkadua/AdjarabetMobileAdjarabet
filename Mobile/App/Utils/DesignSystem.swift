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
        case h6(fontCase: FontCase)
        case body1
        case body2
        case p

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
            case .h1(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 23)
            case .h2(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 18)
            case .h3(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 16)
            case .h4(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 13)
            case .h5(let fontCase): return font(by: language, fontCase: fontCase, pointSize: 11)
            case .h6:               return R.font.pantonNusx3Regular(size: 11)!
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
        public static let backgroundColor: Color        = .fill110()
        public static let tintColor: Color              = .systemWhite()

        public static let placeholderFont: Typography   = .body2

        public static let placeholTextColor: Color      = .separator(alpha: 0.6)
        public static let textFieldTextColor: Color     = .separator(alpha: 1)

        public static let borderWidth: CGFloat          = 1
        public static let borderColor: Color            = .separator()
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
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4), backgorundColor: .fill110(), overlayColor: .fill140(alpha: 0.9))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .fill110(), overlayColor: .baseBg300(alpha: 0.4))
                    }
                case .tertiary(let state, let size):
                    let sd = sizeDescription(for: size)
                    switch state {
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemRed150())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8), backgorundColor: .systemRed150(), overlayColor: .baseBg300(alpha: 0.2))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemRed150(), overlayColor: .baseBg300(alpha: 0.3))
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(), backgorundColor: .systemRed150(), overlayColor: .baseBg300(alpha: 0.4))
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite(alpha: 0.4), backgorundColor: .systemRed150(), overlayColor: .fill140(alpha: 0.5))
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
                    case .normal:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator())
                    case .hovered:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8))
                    case .acvite:   return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator())
                    case .focused:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator())
                    case .disabled: return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .separator(alpha: 0.8))
                    case .loading:  return .init(typograhy: sd.typograhy, contentEdgeInsets: sd.contentEdgeInsets, textColor: .systemWhite())
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
