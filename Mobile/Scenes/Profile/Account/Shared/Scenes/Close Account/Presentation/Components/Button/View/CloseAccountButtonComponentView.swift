//
//  CloseAccountButtonComponentView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class CloseAccountButtonComponentView: UIView {
    private var diposeBag = DisposeBag()
    private var viewModel: CloseAccountButtonComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: CloseAccountButtonComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel?.action.subscribe(onNext: {_ in
        }).disposed(by: diposeBag)

        viewModel.didBind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 10)
    }
}

extension CloseAccountButtonComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.close_account_button_title.localized()

        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAccountAction))
        addGestureRecognizer(tap)
    }

    @objc private func closeAccountAction() {
        viewModel?.didSelect()
    }
}
