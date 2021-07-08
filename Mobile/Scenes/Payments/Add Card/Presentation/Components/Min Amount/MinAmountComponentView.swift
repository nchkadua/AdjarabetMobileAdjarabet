//
//  MinAmountComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class MinAmountComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: MinAmountComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var instructionTitleLabel: UILabel!
    @IBOutlet weak private var footerBgView: UIView!
    @IBOutlet weak private var minAmountTitleLabel: UILabel!
    @IBOutlet weak private var minAmountButton: ABButton!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: MinAmountComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()
        viewModel.didBind()
    }

    @objc private func minAmountButtonDidTap() {
        viewModel.didClickMinimumAmountButton()
    }
}

extension MinAmountComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        roundCorners(radius: 8)
        view.setBackgorundColor(to: .tertiaryFill())
        footerBgView.setBackgorundColor(to: .tertiaryBg())

        iconImageView.image = R.image.cardManagement.card()

        instructionTitleLabel.setFont(to: .footnote(fontCase: .lower))
        instructionTitleLabel.setTextColor(to: .primaryText())
        instructionTitleLabel.text = R.string.localization.add_card_minimum_amount_title.localized()

        minAmountTitleLabel.setFont(to: .footnote(fontCase: .lower))
        minAmountTitleLabel.setTextColor(to: .primaryText())
        minAmountTitleLabel.text = R.string.localization.add_card_minimum_amount.localized()

        minAmountButton.setStyle(to: .primary(state: .active, size: .xs))
        minAmountButton.setTitleWithoutAnimation("1.00 ₾", for: .normal)
        minAmountButton.setTintColor(to: .primaryText())
        minAmountButton.setButtonImage(R.image.components.profileCell.copy() ?? UIImage(), alignment: .right)
        minAmountButton.addTarget(self, action: #selector(minAmountButtonDidTap), for: .touchUpInside)
    }
}
