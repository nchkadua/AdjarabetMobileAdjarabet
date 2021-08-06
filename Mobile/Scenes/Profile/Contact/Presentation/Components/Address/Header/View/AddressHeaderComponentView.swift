//
//  AddressHeaderComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class AddressHeaderComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AddressHeaderComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var separator: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: AddressHeaderComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title): self?.set(title)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(_ title: String) {
        titleLabel.text = title.uppercased()
    }
}

extension AddressHeaderComponentView: Xibable {
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
        separator.setBackgorundColor(to: .nonOpaque())

        titleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
    }
}
