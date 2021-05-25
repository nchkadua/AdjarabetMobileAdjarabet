//
//  PaymentMethodComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import Nuke

class PaymentMethodComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: PaymentMethodComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var iconImageView: UIImageView!

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
        roundCorners(.allCorners, radius: 20)
    }

    public func setAndBind(viewModel: PaymentMethodComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let iconUrl): self?.set(iconUrl: iconUrl)
            case .select: self?.select()
            case .deselect: self?.deselect()
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(iconUrl: String) {
        guard let url = URL(string: iconUrl) else { return }
        iconImageView.sd_setImage(with: url)

        accessibilityIdentifier = viewModel.params.flowId
    }

    private func select() {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = DesignSystem.Color.primaryRed().value
        }
    }

    private func deselect() {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = DesignSystem.Color.systemGrey5().value
        }
    }
}

extension PaymentMethodComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.systemGrey5().value
    }
}
