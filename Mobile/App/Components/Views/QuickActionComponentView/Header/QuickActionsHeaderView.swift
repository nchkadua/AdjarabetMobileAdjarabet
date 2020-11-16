//
//  QuickActionsHeaderView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class QuickActionsHeaderView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: QuickActionsHeaderViewModel!

    // MARK: Outlets
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    public override init(frame: CGRect) {
       super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    public func setAndBind(viewModel: QuickActionsHeaderViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setTitle:
                self?.setTitle()
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setTitle() {
        titleLabel.text = R.string.localization.quick_actions_header_title()
    }
}

extension QuickActionsHeaderView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.secondaryBg().value

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        setTitle()
    }
}
