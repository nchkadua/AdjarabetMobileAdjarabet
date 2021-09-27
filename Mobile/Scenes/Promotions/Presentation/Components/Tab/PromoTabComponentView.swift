//
//  PromoTabComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 22.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class PromoTabComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: PromoTabComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var buttonPublic: UIButton!
    @IBOutlet weak private var buttonPrivate: UIButton!
    // MARK: Constraint Outlets
    @IBOutlet weak private var buttonPublicCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak private var buttonPrivateCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak private var buttonContainerCenterConstraint: NSLayoutConstraint!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: PromoTabComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel.didBind()
    }

    @objc private func buttonPublicDidTap() {
        buttonPublicSetActive(true)
        buttonPrivateSetActive(false)

        viewModel.buttonPublicDidTap()
    }

    @objc private func buttonPrivateDidTap() {
        buttonPublicSetActive(false)
        buttonPrivateSetActive(true)

        viewModel.buttonPrivateDidTap()
    }

    // Button animation
    private func buttonPublicSetActive(_ active: Bool) {
        switch active {
        case true:
            UIView.animate(withDuration: 0.3, animations: { [self] in
                buttonPublic.setTitleColor(to: .primaryText(), for: .normal)
                buttonContainerCenterConstraint.constant = 30

                layoutIfNeeded()
            })
        case false:
            UIView.animate(withDuration: 0.3, animations: { [self] in
                buttonPublic.setTitleColor(to: .tertiaryText(), for: .normal)
                buttonContainerCenterConstraint.constant = -20

                layoutIfNeeded()
            })
        }
    }

    private func buttonPrivateSetActive(_ active: Bool) {
        switch active {
        case true:
            UIView.animate(withDuration: 0.3, animations: { [self] in
                buttonPrivate.setTitleColor(to: .primaryText(), for: .normal)
            })
        case false:
            UIView.animate(withDuration: 0.3, animations: { [self] in
                buttonPrivate.setTitleColor(to: .tertiaryText(), for: .normal)
            })
        }
    }
}

extension PromoTabComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .primaryBg())

        buttonPublic.setFont(to: .title2(fontCase: .upper, fontStyle: .bold))
        buttonPublic.setTitleColor(to: .primaryText(), for: .normal)
        buttonPublic.setTitle(R.string.localization.promotions_public_button_title.localized().uppercased(), for: .normal)
        buttonPublic.isHighlighted = false
        buttonPublic.addTarget(self, action: #selector(buttonPublicDidTap), for: .touchUpInside)

        buttonPrivate.setFont(to: .title2(fontCase: .upper, fontStyle: .bold))
        buttonPrivate.setTitleColor(to: .tertiaryText(), for: .normal)
        buttonPrivate.setTitle(R.string.localization.promotions_private_button_title.localized().uppercased(), for: .normal)
        buttonPrivate.isHighlighted = false
        buttonPrivate.addTarget(self, action: #selector(buttonPrivateDidTap), for: .touchUpInside)
    }
}
