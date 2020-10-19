//
//  NotificationsHeaderComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class NotificationsHeaderComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: NotificationsHeaderComponentViewModel!

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

    public func setAndBind(viewModel: NotificationsHeaderComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title):
                self?.set(title: title)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(title: String) {
        titleLabel.text = title
    }
}

extension NotificationsHeaderComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.baseBg300().value

        titleLabel.setFont(to: .body1)
        titleLabel.setTextColor(to: .systemWhite(alpha: 0.7))
    }
}
