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
        public static var white: UIColor { R.color.colorGuide.neutral.white()! }
        public static var neutral100: UIColor { R.color.colorGuide.neutral.neutral100()! }
        public static var neutral200: UIColor { R.color.colorGuide.neutral.neutral200()! }
        public static var neutral300: UIColor { R.color.colorGuide.neutral.neutral300()! }
        public static var neutral400: UIColor { R.color.colorGuide.neutral.neutral400()! }
        public static var neutral500: UIColor { R.color.colorGuide.neutral.neutral500()! }
        public static var neutral600: UIColor { R.color.colorGuide.neutral.neutral600()! }
        public static var neutral700: UIColor { R.color.colorGuide.neutral.neutral700()! }
        public static var neutral800: UIColor { R.color.colorGuide.neutral.neutral800()! }

        /// Primary colors
        public static var primary200: UIColor { R.color.colorGuide.primary.primary200()! }
        public static var primary400: UIColor { R.color.colorGuide.primary.primary400()! }

        /// Secondary colors
        public static var secondary200: UIColor { R.color.colorGuide.secondary.secondary200()! }
        public static var secondary400: UIColor { R.color.colorGuide.secondary.secondary400()! }

        /// Semantic colors
        public static var success: UIColor { R.color.colorGuide.semantic.success()! }
        public static var warning: UIColor { R.color.colorGuide.semantic.warning()! }
        public static var error: UIColor { R.color.colorGuide.semantic.error()! }
    }

    /// Design system typography
    public enum Typography {
        case h1
        case h2
        case h3
        case h4
        case h5
        case body1
        case body2
        case p

        /// Concrete description for each case
        public var description: Description {
            switch self {
            case .h1:    return Description(font: R.font.pantonMtav3Bold(size: 28)!, lineSpasing: 0.7, lineHeight: 44)
            case .h2:    return Description(font: R.font.pantonMtav3Bold(size: 23)!, lineSpasing: 0.7, lineHeight: 36)
            case .h3:    return Description(font: R.font.pantonMtav3Bold(size: 16)!, lineSpasing: 0.5, lineHeight: 24)
            case .h4:    return Description(font: R.font.pantonMtav3Bold(size: 14)!, lineSpasing: 0.3, lineHeight: 24)
            case .h5:    return Description(font: R.font.pantonMtav3Bold(size: 11)!, lineSpasing: 0.5, lineHeight: 16)
            case .body1: return Description(font: R.font.firaGOMedium(size: 13)!, lineSpasing: 0, lineHeight: 20)
            case .body2: return Description(font: R.font.firaGOMedium(size: 11)!, lineSpasing: 0, lineHeight: 16)
            case .p:     return Description(font: R.font.firaGORegular(size: 13)!, lineSpasing: 0, lineHeight: 20)
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
    }
}
