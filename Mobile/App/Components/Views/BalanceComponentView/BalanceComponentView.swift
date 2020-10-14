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
    @IBOutlet weak private var pokerBalanceTitleLabel: UILabel!
    @IBOutlet weak private var pokerBalanceValueLabel: UILabel!
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
            case .set(let totalBalance, let pokerBalance):
                self?.setupUI(totalBalance: totalBalance, pokerBalance: pokerBalance)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(totalBalance: Double, pokerBalance: Double) {
        totalBalanceValueLabel.text = "\(totalBalance.formattedBalance ?? "0") ₾"
        pokerBalanceValueLabel.text = "\(pokerBalance) ₾"
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
        view.backgroundColor = DesignSystem.Color.baseBg300().value

        bgView.setBackgorundColor(to: .baseBg100())
        bgView.layer.cornerRadius = 5

        myBalanceTitleButton.setTitleColor(to: .systemWhite(), for: .normal)
        myBalanceTitleButton.setFont(to: .h4(fontCase: .lower))
        myBalanceTitleButton.setTitleWithoutAnimation(R.string.localization.balance_title(), for: .normal)
        myBalanceTitleButton.addTarget(self, action: #selector(myBalanceAction), for: .touchUpInside)

        myBalanceImageButton.setImage(R.image.components.gameLauncher.in(), for: .normal)
        myBalanceImageButton.setTintColor(to: .systemWhite())
        myBalanceImageButton.addTarget(self, action: #selector(myBalanceAction), for: .touchUpInside)

        totalBalanceTitleLabel.setTextColor(to: .systemWhite())
        totalBalanceTitleLabel.setFont(to: .h4(fontCase: .lower))
        totalBalanceTitleLabel.setFont(to: .body1)

        pokerBalanceTitleLabel.setTextColor(to: .systemWhite())
        pokerBalanceTitleLabel.setFont(to: .h4(fontCase: .lower))
        pokerBalanceTitleLabel.setFont(to: .body1)

        totalBalanceValueLabel.setTextColor(to: .systemWhite())
        totalBalanceValueLabel.setFont(to: .h1(fontCase: .upper))
        totalBalanceTitleLabel.text = R.string.localization.total_balance()

        pokerBalanceValueLabel.setTextColor(to: .systemWhite(alpha: 0.7))
        pokerBalanceValueLabel.setFont(to: .h1(fontCase: .upper))
        pokerBalanceTitleLabel.text = R.string.localization.poker_balance()

        withdrawButton.setBackgorundColor(to: .baseBg100())
        withdrawButton.setTitleColor(to: .systemWhite(), for: .normal)
        withdrawButton.setFont(to: .h4(fontCase: .lower))
        withdrawButton.layer.borderWidth = 1
        withdrawButton.layer.borderColor = DesignSystem.Color.separator().value.cgColor
        withdrawButton.layer.cornerRadius = 5
        withdrawButton.setTitleWithoutAnimation(R.string.localization.withdraw_button_title(), for: .normal)
        withdrawButton.addTarget(self, action: #selector(withdrawButtonAction), for: .touchUpInside)

        depositButton.setBackgorundColor(to: .systemGreen150())
        depositButton.setTitleColor(to: .systemWhite(), for: .normal)
        depositButton.setFont(to: .h4(fontCase: .lower))
        depositButton.layer.cornerRadius = 5
        depositButton.setTitleWithoutAnimation(R.string.localization.deposit_button_title(), for: .normal)
        depositButton.addTarget(self, action: #selector(depositButtonAction), for: .touchUpInside)
    }
}
