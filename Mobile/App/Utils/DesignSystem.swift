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

        public var value: Int { rawValue }
    }
}
