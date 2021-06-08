//
//  AccountSecurityMessagesComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class AccountSecurityMessagesComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AccountSecurityMessagesComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var setParametersButton: UIButton!
    @IBOutlet weak private var setParametersSwitch: UISwitch!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(.allCorners, radius: 8)
    }

    public func setAndBind(viewModel: AccountSecurityMessagesComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let params):
                self?.set(params: params)
            case .parametersSwitchToggledTo:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(params: AccountSecurityMessagesComponentViewModelParams) {
        titleLabel.text = params.title
        descriptionLabel.text = params.description
        setParametersButton.setTitle(params.buttonTitle, for: .normal)
        setParametersSwitch.isOn = params.switchState
    }
    @IBAction func parametersSwitchToggled(_ sender: UISwitch) {
        viewModel.parametersSwitchToggled(to: sender.isOn)
    }
}

extension AccountSecurityMessagesComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        setBackgorundColor(to: .secondaryBg())
        view.setBackgorundColor(to: .tertiaryBg())

        titleLabel.setFont(to: .body2(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())

        descriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        descriptionLabel.setTextColor(to: .secondaryText())

        setParametersButton.titleLabel?.setFont(to: .footnote(fontCase: .lower, fontStyle: .semiBold))
        setParametersButton.setTitleColor(to: .systemBlue(), for: .normal)

        setParametersSwitch.onTintColor = DesignSystem.Color.primaryRedDark().value
        setParametersSwitch.tintColor = DesignSystem.Color.secondaryBg().value
    }
}
