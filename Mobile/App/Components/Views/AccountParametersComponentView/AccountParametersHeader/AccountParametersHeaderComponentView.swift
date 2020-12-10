//
//  AccountParametersHeaderComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class AccountParametersHeaderComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AccountParametersHeaderComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: AccountParametersHeaderComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let params):
                self?.set(params: params)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(params: AccountParametersHeaderComponentViewModelParams) {
        titleLabel.text = params.title
    }
}

extension AccountParametersHeaderComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .subHeadline(fontCase: .lower))
    }
}
