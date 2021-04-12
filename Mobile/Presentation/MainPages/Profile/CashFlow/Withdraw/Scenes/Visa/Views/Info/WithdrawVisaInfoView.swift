//
//  WithdrawVisaInfoView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class WithdrawVisaInfoView: UIView, Xibable {
    /* Main View */
    @IBOutlet private weak var view: UIView!
    /* Limits */
    // Minimum Limit View
    @IBOutlet private weak var minimumLimitView: UIView!
    @IBOutlet private weak var minimumTitleLabel: UILabel!
    @IBOutlet private weak var minimumAmountLabel: UILabel!
    // Disposable Limit View
    @IBOutlet private weak var disposableLimitView: UIView!
    @IBOutlet private weak var disposableTitleLabel: UILabel!
    @IBOutlet private weak var disposableAmountLabel: UILabel!
    // Daily Limit View
    @IBOutlet private weak var dailyLimitView: UIView!
    @IBOutlet private weak var dailyTitleLabel: UILabel!
    @IBOutlet private weak var dailyAmountLabel: UILabel!
    /* Steps */
    // View
    @IBOutlet private weak var stepsView: UIView!
    // Title
    @IBOutlet private weak var stepsTitleLabel: UILabel!
    // Step 1
    @IBOutlet private weak var step1TitleLabel: UILabel!
    @IBOutlet private weak var step1DescriptionLabel: UILabel!
    // Step 2
    @IBOutlet private weak var step2TitleLabel: UILabel!
    @IBOutlet private weak var step2DescriptionLabel: UILabel!
    // Step 3
    @IBOutlet private weak var step3TitleLabel: UILabel!
    @IBOutlet private weak var step3DescriptionLabel: UILabel!
    /* Separator */
    @IBOutlet private weak var separator: UIView!
    /* Instruction */
    @IBOutlet private weak var instructionTitleLabel: UILabel!
    @IBOutlet private weak var instructionDescriptionLabel: UILabel!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    func setupUI() {
        setupLimits()
        setupSteps()
        setupSeparator()
        setupInstruction()
    }

    private func setupLimits() {
        setupLimit(view: minimumLimitView, title: minimumTitleLabel, amount: minimumAmountLabel, titleText: R.string.localization.withdraw_minimum.localized())
        setupLimit(view: disposableLimitView, title: disposableTitleLabel, amount: disposableAmountLabel, titleText: R.string.localization.withdraw_disposable.localized())
        setupLimit(view: dailyLimitView, title: dailyTitleLabel, amount: dailyAmountLabel, titleText: R.string.localization.withdraw_daily.localized())
    }

    private func setupLimit(view: UIView, title: UILabel, amount: UILabel, titleText: String) {
        view.setBackgorundColor(to: .thin())

        title.setTextColor(to: .secondaryText())
        title.setFont(to: .caption2(fontCase: .lower, fontStyle: .regular))
        title.text = titleText

        amount.setTextColor(to: .primaryText())
        amount.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
    }

    private func setupSteps() {
        stepsView.setBackgorundColor(to: .thin())

        stepsTitleLabel.setTextColor(to: .primaryText())
        stepsTitleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        stepsTitleLabel.text = R.string.localization.withdraw_cash_out_instruction.localized()

        setupStep(title: step1TitleLabel, description: step1DescriptionLabel, descriptionText: R.string.localization.withdraw_step_1.localized())
        setupStep(title: step2TitleLabel, description: step2DescriptionLabel, descriptionText: R.string.localization.withdraw_step_2.localized())
        setupStep(title: step3TitleLabel, description: step3DescriptionLabel, descriptionText: R.string.localization.withdraw_step_3.localized())
    }

    private func setupStep(title: UILabel, description: UILabel, descriptionText: String) {
        title.setBackgorundColor(to: .systemGrey5())
        title.setTextColor(to: .primaryText())
        title.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))

        description.setTextColor(to: .secondaryText())
        description.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        description.text = descriptionText
    }

    private func setupSeparator() {
        separator.setBackgorundColor(to: .opaque())
    }

    private func setupInstruction() {
        instructionTitleLabel.setTextColor(to: .primaryText())
        instructionTitleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        instructionTitleLabel.text = R.string.localization.withdraw_cash_out.localized()

        instructionDescriptionLabel.setTextColor(to: .secondaryText())
        instructionDescriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        instructionDescriptionLabel.text = R.string.localization.withdraw_instruction.localized()
    }
}
