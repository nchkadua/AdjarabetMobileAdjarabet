//
//  DesignSystem.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DesignSystem {
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
        /// Availbe information about concrete typography
        public struct Description {
            public let font: UIFont
            public let lineSpasing: CGFloat
            public let lineHeight: CGFloat
        }

        #warning("Fonts needs to be set to PantonMtav3 & FiraGO")
        public static var h1: Description { Description(font: .systemFont(ofSize: 28), lineSpasing: 0.7, lineHeight: 44) }
        public static var h2: Description { Description(font: .systemFont(ofSize: 23), lineSpasing: 0.7, lineHeight: 36) }
        public static var h3: Description { Description(font: .systemFont(ofSize: 16), lineSpasing: 0.5, lineHeight: 24) }
        public static var h4: Description { Description(font: .systemFont(ofSize: 14), lineSpasing: 0.3, lineHeight: 24) }
        public static var h5: Description { Description(font: .systemFont(ofSize: 11), lineSpasing: 0.5, lineHeight: 16) }
        public static var body1: Description { Description(font: .systemFont(ofSize: 13), lineSpasing: 0, lineHeight: 20) }
        public static var body2: Description { Description(font: .systemFont(ofSize: 11), lineSpasing: 0, lineHeight: 16) }
        public static var p: Description { Description(font: .systemFont(ofSize: 13), lineSpasing: 0, lineHeight: 20) }
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
