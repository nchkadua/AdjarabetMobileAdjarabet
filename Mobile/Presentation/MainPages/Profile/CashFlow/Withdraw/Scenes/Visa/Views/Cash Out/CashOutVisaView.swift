//
//  CashOutVisaView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class CashOutVisaView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var amountInputView: ABInputView!
    @IBOutlet private weak var accountPickerView: ABInputView!
    @IBOutlet private weak var addAccountButton: UIButton!
    /* Summary */
    @IBOutlet private weak var summaryView: UIView!
    // Fee
    @IBOutlet private weak var feeTitleLabel: UILabel!
    @IBOutlet private weak var feeAmountView: UIView!
    @IBOutlet private weak var feeAmountLabel: UILabel!
    // Total
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalAmountView: UIView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    /* Continue */
    @IBOutlet private weak var continueButton: ABButton!

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
        setupAmountInputView()
        setupAccountPickerView()
        setupAddAccountButton()
        setupSummary()
        setupContinueButton()
    }

    private func setupAmountInputView() {
        amountInputView.setupWith(backgroundColor: .tertiaryBg(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: "თანხა")
        amountInputView.mainTextField.addTarget(self, action: #selector(amountEditingDidBegin), for: .editingDidBegin)
        amountInputView.mainTextField.addTarget(self, action: #selector(amountEditingDidEnd), for: .editingDidEnd)
    }

    @objc private func amountEditingDidBegin() {
        amountInputView.set(text: "")
        continueButton(isEnabled: false)
    }

    @objc private func amountEditingDidEnd() {
        // event - entered(amount, account)
    }

    private func setupAccountPickerView() {
        accountPickerView.setupWith(backgroundColor: .tertiaryBg(), borderWidth: 0)
        accountPickerView.setPlaceholder(text: "ანგარიში")
        accountPickerView.delegate = self
    }

    private func setupAddAccountButton() {
        addAccountButton.setBackgorundColor(to: .tertiaryBg())
        addAccountButton.addTarget(self, action: #selector(addAccountDidTap), for: .touchUpInside)
    }

    @objc private func addAccountDidTap() {
        // event - added()
    }

    private func setupSummary() {
        // TODO
    }

    private func setupContinueButton() {
        continueButton.setStyle(to: .primary(state: .disabled, size: .large))
        continueButton.setTitleWithoutAnimation("გაგრძელება", for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        continueButton.titleEdgeInsets.bottom = 2
    }

    @objc private func continueButtonDidTap() {
        // event - continued(amount, account)
    }

    /* helpers */

    private func continueButton(isEnabled: Bool) {
        continueButton.isUserInteractionEnabled = isEnabled
        continueButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    private var amount: String {
        amountInputView.text ?? ""
    }

    private var account: Int {
        accountPickerView.pickerView.selectedRow(inComponent: 0)
    }
}

extension CashOutVisaView: ABInputViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // event - selected(account, amount)
    }
}
