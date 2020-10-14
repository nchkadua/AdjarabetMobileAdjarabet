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

class LanguagesButton: ABButton {
    public weak var delegate: LanguagesButtonDelegate?
    @Inject private var languageStorage: LanguageStorage

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        setStyle(to: .textLink(state: .acvite, size: .small))
        setFont(to: .body1)
        setTitleColor(R.color.colorGuide.global.systemWhite(), for: .normal)
        backgroundColor = R.color.colorGuide.global.baseBg100()
        layer.cornerRadius = 5
        titleLabel?.textAlignment = .left

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
