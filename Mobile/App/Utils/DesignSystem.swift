//
//  DesignSystem.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DesignSystem {
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
}
