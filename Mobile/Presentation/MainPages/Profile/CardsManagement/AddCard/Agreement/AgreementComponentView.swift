//
//  AgreementComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class AgreementComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AgreementComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var agreementLabel: UILabel!
    @IBOutlet weak private var agreeButton: UIButton!

    private var agreed = false

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: AgreementComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()
        viewModel.didBind()
    }

    @objc private func agreeButtonDidTap() {
        viewModel.agreementUpdated(agreed: agreed)
        updateView(agreed)
    }

    private func updateView(_ activateButton: Bool) {
        if activateButton {
            layer.borderColor = DesignSystem.Color.systemBlue().value.cgColor
            agreementLabel.setTextColor(to: .primaryText())
            agreeButtonActivated()
        } else {
            layer.borderColor = DesignSystem.Color.querternaryFill().value.cgColor
            agreementLabel.setTextColor(to: .secondaryText())
            agreeButtonDeactivated()
        }

        agreed.toggle()
    }

    private func agreeButtonActivated() {
        agreeButton.setBackgorundColor(to: .systemBlue())
        agreeButton.setTintColor(to: .primaryText())
        agreeButton.setImage(R.image.cardManagement.checkmark(), for: .normal)
    }

    private func agreeButtonDeactivated() {
        agreeButton.setBackgorundColor(to: .secondaryBg())
        agreeButton.setTintColor(to: .querternaryFill())
        agreeButton.setImage(R.image.cardManagement.oval(), for: .normal)
    }
}

extension AgreementComponentView: Xibable {
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
        layer.cornerRadius = 8
        layer.borderWidth = 1

        agreementLabel.setFont(to: .footnote(fontCase: .lower))
        agreementLabel.text = R.string.localization.add_card_terms.localized()

        updateView(agreed)
        agreeButton.rounded()
        agreeButton.addTarget(self, action: #selector(agreeButtonDidTap), for: .touchUpInside)
    }
}
