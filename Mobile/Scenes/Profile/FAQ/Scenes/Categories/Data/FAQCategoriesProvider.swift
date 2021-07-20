//
//  FAQCategoriesProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class FAQCategoriesProvider {
    public static func items() -> [FAQCategory] {
        [
            FAQCategory(icon: R.image.faQ.transactions()!, title: R.string.localization.faq_transactions_title.localized(), subtitle: R.string.localization.faq_transactions_subtitle.localized()),
            FAQCategory(icon: R.image.faQ.verification()!, title: R.string.localization.faq_verification_title.localized(), subtitle: R.string.localization.faq_verification_subtitle.localized()),
            FAQCategory(icon: R.image.faQ.incognito()!, title: R.string.localization.faq_incognito_card_title.localized(), subtitle: R.string.localization.faq_incognito_card_subtitle.localized()),
            FAQCategory(icon: R.image.faQ.faq()!, title: R.string.localization.faq_faq_title.localized(), subtitle: R.string.localization.faq_faq_subtitle.localized()),
            FAQCategory(icon: R.image.faQ.soc()!, title: R.string.localization.faq_social_platforms_title.localized(), subtitle: R.string.localization.faq_social_platforms_subtitle.localized())
        ]
    }
}

struct FAQCategory {
    let icon: UIImage
    let title: String
    let subtitle: String
}
