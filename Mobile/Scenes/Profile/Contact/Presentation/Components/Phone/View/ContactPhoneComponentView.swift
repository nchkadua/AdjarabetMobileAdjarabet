//
//  ContactPhoneComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

enum ContactNumbers: String {
    case number1 = "+995322711010"
    case number2 = "+995322971010"
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

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            default:
                break
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

    @objc private func callToNumber1() {
        call(ContactNumbers.number1.rawValue)
    }

    @objc private func callToNumber2() {
        call(ContactNumbers.number2.rawValue)
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
        separator.setBackgorundColor(to: .opaque())

        titleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.contact_call_us.localized().uppercased()

        setupButtons()
    }
}
