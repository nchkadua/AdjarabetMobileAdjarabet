//
//  BalanceComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class BalanceComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: BalanceComponentViewModel!
    @Inject private var userSession: UserSessionServices
    @Inject private var languageStorage: LanguageStorage

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var bgView: UIView!
    @IBOutlet weak private var myBalanceTitleButton: UIButton!
    @IBOutlet weak private var myBalanceImageButton: UIButton!
    @IBOutlet weak private var totalBalanceTitleLabel: UILabel!
    @IBOutlet weak private var totalBalanceValueLabel: UILabel!
    @IBOutlet weak private var withdrawButton: UIButton!
    @IBOutlet weak private var depositButton: UIButton!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: BalanceComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let totalBalance): self?.setupUI(totalBalance: totalBalance)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(totalBalance: Double) {
        totalBalanceValueLabel.text = "\(totalBalance.formattedBalance ?? "0") ₾"
    }

    @objc private func myBalanceAction() {
        viewModel.didClickBalance()
    }

    @objc private func withdrawButtonAction() {
        viewModel.didClickWithdraw()
    }

    @objc private func depositButtonAction() {
        viewModel.didClickDeposit()
    }
}

extension BalanceComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    //Fonts should be changed in design system
    func setupUI() {
        view.backgroundColor = DesignSystem.Color.secondaryBg().value

        bgView.setBackgorundColor(to: .tertiaryBg())
        bgView.layer.cornerRadius = 10

        myBalanceTitleButton.setTitleColor(to: .primaryText(), for: .normal)
        myBalanceTitleButton.setFont(to: .footnote(fontCase: .lower))
        myBalanceTitleButton.setTitleWithoutAnimation(R.string.localization.balance_title(), for: .normal)
        myBalanceTitleButton.addTarget(self, action: #selector(myBalanceAction), for: .touchUpInside)

        myBalanceImageButton.setImage(R.image.components.profileCell.arrow(), for: .normal)
        myBalanceImageButton.setTintColor(to: .primaryText())
        myBalanceImageButton.addTarget(self, action: #selector(myBalanceAction), for: .touchUpInside)

        totalBalanceTitleLabel.setTextColor(to: .primaryText())
        totalBalanceTitleLabel.setFont(to: .footnote(fontCase: .lower))
        totalBalanceTitleLabel.text = R.string.localization.total_balance()

        totalBalanceValueLabel.setTextColor(to: .primaryText())
        totalBalanceValueLabel.setFont(to: .title3(fontCase: .upper, fontStyle: .bold))

        withdrawButton.setBackgorundColor(to: .querternaryFill())
        withdrawButton.setTitleColor(to: .primaryText(), for: .normal)
        withdrawButton.setFont(to: .footnote(fontCase: .upper, fontStyle: .semiBold))
        withdrawButton.layer.cornerRadius = 10
        withdrawButton.setTitleWithoutAnimation(R.string.localization.withdraw_button_title(), for: .normal)
        withdrawButton.addTarget(self, action: #selector(withdrawButtonAction), for: .touchUpInside)

        depositButton.setBackgorundColor(to: .primaryRed())
        depositButton.setTitleColor(to: .primaryText(), for: .normal)
        depositButton.setFont(to: .footnote(fontCase: .upper, fontStyle: .semiBold))
        depositButton.layer.cornerRadius = 10
        depositButton.setTitleWithoutAnimation(R.string.localization.deposit_button_title(), for: .normal)
        depositButton.addTarget(self, action: #selector(depositButtonAction), for: .touchUpInside)
    }
}
