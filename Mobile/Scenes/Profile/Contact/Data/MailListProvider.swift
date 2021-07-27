//
//  MailListProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class MailListProvider {
    public static func items() -> [Mail] {
        return [
            Mail(title: R.string.localization.contact_mail_title1.localized(), mail: "contact@adjarabet.com"),
            Mail(title: R.string.localization.contact_mail_title2.localized(), mail: "docs@adjarabet.com")
        ]
    }
}

struct Mail {
    let title: String
    let mail: String
}
