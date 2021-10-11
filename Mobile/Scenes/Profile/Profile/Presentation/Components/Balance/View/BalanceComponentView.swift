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
    @IBOutlet weak private var totalBalanceValueLabel: UILabel!
	@IBOutlet weak private var balancePlaceholderLabel: UILabel!
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
            case .setup(let viewModel): self?.setupUI(viewModel: viewModel)
			case .showTotalBalance: self?.showMainBalance()
			case .showBalancePlaceholder(let placeholder): self?.showBalancePlaceholder(placeholderText: placeholder)
            case .updateBalance(let balance): self?.totalBalanceValueLabel.text = balance
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

	private func showMainBalance() {
		totalBalanceValueLabel.show()
		balancePlaceholderLabel.hide()
	}

	private func showBalancePlaceholder(placeholderText: String) {
		totalBalanceValueLabel.hide()
		balancePlaceholderLabel.text = placeholderText
		balancePlaceholderLabel.show()
	}

    private func setupUI(viewModel: BalanceComponentViewModel) {
		totalBalanceValueLabel.text = viewModel.formattedAmount
		if viewModel.isBalanceShown {
			showMainBalance()
		} else {
			showBalancePlaceholder(placeholderText: viewModel.params.balancePlaceholder)
		}
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

    // Fonts should be changed in design system
    func setupUI() {
        view.setBackgorundColor(to: .secondaryBg())

        bgView.setBackgorundColor(to: .tertiaryBg())
        bgView.layer.cornerRadius = 8

        totalBalanceValueLabel.setTextColor(to: .primaryText())
        totalBalanceValueLabel.setFont(to: .midline(fontCase: .upper, fontStyle: .semiBold))

        withdrawButton.setImage(R.image.profile.minus(), for: .normal)
        withdrawButton.addTarget(self, action: #selector(withdrawButtonAction), for: .touchUpInside)

        depositButton.setImage(R.image.profile.plus(), for: .normal)
        depositButton.addTarget(self, action: #selector(depositButtonAction), for: .touchUpInside)
    }
}
