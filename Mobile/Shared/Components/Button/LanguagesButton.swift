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
        layer.cornerRadius = 0
        clipsToBounds = true
        titleLabel?.textAlignment = .left
//        titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        setFont(to: .subHeadline(fontCase: .upper, fontStyle: .semiBold))
        setTitleColor(R.color.colorGuide.textColors.primary(), for: .normal)
        backgroundColor = .clear

        let chosenLanguageIdentifier = languageStorage.currentLanguage.localizableIdentifier

//        setTitleWithoutAnimation(getLanguage(by: chosenLanguageIdentifier), for: .normal)
        setImage(getIcon(by: chosenLanguageIdentifier).withRenderingMode(.alwaysOriginal), for: .normal)
        addTarget(self, action: #selector(updateButton), for: .touchUpInside)
    }

    private func getLanguage(by prefix: String) -> String {
        var result = ""

        for language in Language.allCases where prefix == language.localizableIdentifier {
            result = language.title
        }

        return result
    }

    private func getIcon(by prefix: String) -> UIImage {
        var result = UIImage()

        for language in Language.allCases where prefix == language.localizableIdentifier {
            result = language.languageIcon
        }

        return result
    }

    @objc private func updateButton() {
        let nextLanguage = languageStorage.currentLanguage.next()

        changeLanguage(to: nextLanguage)
//        setTitleWithoutAnimation(getLanguage(by: nextLanguage.localizableIdentifier), for: .normal)
        setImage(getIcon(by: nextLanguage.localizableIdentifier).withRenderingMode(.alwaysOriginal), for: .normal)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func changeLanguage(to language: Language) {
        DefaultLanguageStorage.shared.update(language: language)
        delegate?.languageDidChange(language: language)
    }
}
