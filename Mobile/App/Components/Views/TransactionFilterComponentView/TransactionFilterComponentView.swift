//
//  TransactionFilterComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class TransactionFilterComponentView: UIView {
    private var diposeBag = DisposeBag()
    private var viewModel: TransactionFilterComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var separator: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var checkbox: ABCheckbox!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: TransactionFilterComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let checked):
                self?.set(title: title, checked: checked)
            }
        }).disposed(by: diposeBag)

        viewModel.didBind()
    }

    private func set(title: String, checked: Bool) {
        titleLabel.text = title
        checkbox.isSelected = checked
    }
}

extension TransactionFilterComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = .clear
        separator.setBackgorundColor(to: .nonOpaque())
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .headline(fontCase: .lower))
    }
}
