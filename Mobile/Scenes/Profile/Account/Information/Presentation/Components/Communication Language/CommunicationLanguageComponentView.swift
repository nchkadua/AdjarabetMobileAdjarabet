//
//  CommunicationLanguageComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 12.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class CommunicationLanguageComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: CommunicationLanguageComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var placeholderLabel: UILabel!
    @IBOutlet weak private var fakeTextField: UITextField!

    private var selectedIndex = 0

    public var pickerView = UIPickerView()
    private let communicationLanguages = [
        CommunicationLanguage(title: R.string.localization.account_info_ge.localized(), prefix: "GEO", language: .georgian),
        CommunicationLanguage(title: R.string.localization.account_info_en.localized(), prefix: "ENG", language: .english),
        CommunicationLanguage(title: R.string.localization.account_info_rus.localized(), prefix: "RUS", language: .russian)
    ]

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: CommunicationLanguageComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 10)
        setupPickerView()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .setLanguage(let language):
                let index = self.communicationLanguage(from: language)
                self.selectedIndex = index
                self.placeholderLabel.text = self.communicationLanguages[index].title
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupPickerView() {
        pickerView.backgroundColor = DesignSystem.Color.secondaryBg().value
        pickerView.delegate = self
        pickerView.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()

        toolBar.tintColor = DesignSystem.Color.primaryText().value
        toolBar.barTintColor = DesignSystem.Color.secondaryBg().value
        let doneButton = UIBarButtonItem(title: R.string.localization.cashflow_done_button_title(), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDidTap))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([flexibleSpace, doneButton], animated: false)

        fakeTextField.inputView = pickerView
        fakeTextField.inputAccessoryView = toolBar
    }

    @objc private func doneDidTap() {
        fakeTextField.resignFirstResponder()
        let language = communicationLanguages[selectedIndex].language
        viewModel?.doneTapped(selectedLanguage: language)
    }

    private func communicationLanguage(from language: CommunicationLanguageEntity) -> Int {
        return communicationLanguages.firstIndex(where: { cl in cl.language == language })!
    }
}

extension CommunicationLanguageComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.account_info_communication_lang.localized()

        placeholderLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        placeholderLabel.setTextColor(to: .secondaryText())
     // placeholderLabel.text = communicationLanguages.first?.title

        fakeTextField.borderStyle = .none
        fakeTextField.tintColor = .clear
    }
}

// MARK: Delegate methods
extension CommunicationLanguageComponentView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return communicationLanguages.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return communicationLanguages[row].prefix
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placeholderLabel.text = communicationLanguages[row].title
        selectedIndex = row
    }
}

struct CommunicationLanguage {
    let title: String
    let prefix: String
    let language: CommunicationLanguageEntity
}
