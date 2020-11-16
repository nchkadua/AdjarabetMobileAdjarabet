//
//  LanguagesButton.swift
//  Mobile
//
//  Created by Nika Chkadua on 9/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

protocol LanguagesButtonDelegate: class {
    func languageDidChange(language: Language)
}

class LanguagesButton: UIButton {
    public weak var delegate: LanguagesButtonDelegate?
    @Inject private var languageStorage: LanguageStorage

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 25
        clipsToBounds = true
        titleLabel?.textAlignment = .left

        setFont(to: .caption2(fontCase: .upper, fontStyle: .semiBold))
        setTitleColor(R.color.colorGuide.textColors.primary(), for: .normal)
        backgroundColor = R.color.colorGuide.systemBackground.tertiary()

        let chosenLanguageIdentifier = languageStorage.currentLanguage.localizableIdentifier

        setTitleWithoutAnimation(getLanguage(by: chosenLanguageIdentifier), for: .normal)
        addTarget(self, action: #selector(updateButton), for: .touchUpInside)
    }

    private func getLanguage(by prefix: String) -> String {
        var result = ""

        for language in Language.allCases where prefix == language.localizableIdentifier {
            result = ("\(language.flag) \(language.title)")
        }

        return result
    }

    @objc private func updateButton() {
        let nextLanguage = languageStorage.currentLanguage.next()

        changeLanguage(to: nextLanguage)
        setTitleWithoutAnimation(getLanguage(by: nextLanguage.localizableIdentifier), for: .normal)

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func changeLanguage(to language: Language) {
        DefaultLanguageStorage.shared.update(language: language)
        delegate?.languageDidChange(language: language)
    }
}
