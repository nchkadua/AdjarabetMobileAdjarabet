//
//  AccountParametersComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class AccountParametersComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AccountParametersComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var arrowImageView: UIImageView!
    @IBOutlet weak private var separatorView: UIView!

    private var corners: UIRectCorner = []

    // MARK: Lifecycle methods

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: AccountParametersComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let params):
                self?.set(params: params)
            case .didSelect:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    // MARK: Setup methods

    private func set(params: AccountParametersComponentViewModelParams) {
        titleLabel.text = params.title
        iconImageView.image = params.icon
        separatorView.isHidden = params.hideSeparator

        self.corners = params.corners
    }
}

extension AccountParametersComponentView: Xibable {
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

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))

        arrowImageView.setTintColor(to: .secondaryText())
        iconImageView.setTintColor(to: .primaryText())

        separatorView.setBackgorundColor(to: .tertiaryBg())
    }
}
