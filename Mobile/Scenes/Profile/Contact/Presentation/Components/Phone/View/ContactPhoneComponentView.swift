//
//  ContactPhoneComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

struct ContactNumbers {
    let number1: String?
    let number2: String?
}

class ContactPhoneComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: ContactPhoneComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var call1Button: UIButton!
    @IBOutlet weak private var call2Button: UIButton!
    @IBOutlet weak private var separator: UIView!

    var contactNumbers = ContactNumbers(number1: "", number2: "")

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: ContactPhoneComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setupWithPhoneNumbers(let numbers): self?.setupWith(numbers)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupButtons() {
        call1Button.setImage(R.image.contact.call1()?.withRenderingMode(.alwaysOriginal), for: .normal)
        call1Button.addTarget(self, action: #selector(callToNumber1), for: .touchUpInside)

        call2Button.setImage(R.image.contact.call2()?.withRenderingMode(.alwaysOriginal), for: .normal)
        call2Button.addTarget(self, action: #selector(callToNumber2), for: .touchUpInside)
    }

    private func setupWith(_ phoneNumbers: [String]) {
        switch phoneNumbers.count {
        case 1:
            contactNumbers = ContactNumbers(number1: phoneNumbers[0], number2: "")
            call2Button.isHidden = true
        case 2:
            contactNumbers = ContactNumbers(number1: phoneNumbers[0], number2: phoneNumbers[1])
            call2Button.isHidden = false
        default:
            call1Button.alpha = 0.3
            call2Button.alpha = 0.3
            call1Button.isUserInteractionEnabled = false
            call2Button.isUserInteractionEnabled = false
        }
    }

    @objc private func callToNumber1() {
        call(contactNumbers.number1 ?? "")
    }

    @objc private func callToNumber2() {
        call(contactNumbers.number2 ?? "")
    }

    private func call(_ number: String) {
        guard let number = URL(string: "tel://" + number) else { return }
        UIApplication.shared.open(number)
    }
}

extension ContactPhoneComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .secondaryBg())
        separator.setBackgorundColor(to: .nonOpaque())

        titleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.contact_call_us.localized().uppercased()

        setupButtons()
    }
}
