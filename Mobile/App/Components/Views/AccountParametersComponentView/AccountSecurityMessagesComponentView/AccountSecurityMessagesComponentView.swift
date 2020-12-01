//
//  AccountSecurityMessagesComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class AccountSecurityMessagesComponentView: UIView {
    private var diposeBag = DisposeBag()
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
        roundCorners(.allCorners, radius: 10)
    }

    public func setAndBind(viewModel: AccountSecurityMessagesComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let params):
                self?.set(params: params)
            }
        }).disposed(by: diposeBag)

        viewModel.didBind()
    }

    private func set(params: AccountSecurityMessagesComponentViewModelParams) {
        titleLabel.text = params.title
        descriptionLabel.text = params.description
        setParametersButton.setTitle(params.buttonTitle, for: .normal)
        setParametersSwitch.isOn = params.switchState
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
        view.setBackgorundColor(to: .secondaryBg())
        titleLabel.setFont(to: .subHeadline(fontCase: .lower))
        titleLabel.setTextColor(to: .primaryText())
        descriptionLabel.setFont(to: .caption2(fontCase: .lower))
        descriptionLabel.setTextColor(to: .secondaryText())
        setParametersSwitch.onTintColor = DesignSystem.Color.primaryRedDark().value
        setParametersSwitch.tintColor = DesignSystem.Color.secondaryBg().value
    }
}
