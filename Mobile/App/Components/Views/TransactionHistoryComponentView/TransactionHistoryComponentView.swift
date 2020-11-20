//
//  TransactionHistoryComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class TransactionHistoryComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: TransactionHistoryComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var iconContainerView: UIView!
    @IBOutlet weak private var separator: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setupViewLayers()
    }

    public func setAndBind(viewModel: TransactionHistoryComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }
    private func bind() {
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let transactionHistory):
                self?.set(transactionHistory: transactionHistory)
            default:
                break
            }
        }).disposed(by: disposeBag)
        viewModel.didBind()
    }
    private func set(transactionHistory: TransactionHistory) {
        titleLabel.text = transactionHistory.title
        subtitleLabel.text = transactionHistory.subtitle
        amountLabel.text = transactionHistory.amount
        iconImageView.image = transactionHistory.icon
    }
    private func setupViewLayers() {
        iconContainerView.roundCorners(.allCorners, radius: iconContainerView.frame.height / 2)
    }
}

extension TransactionHistoryComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }
    func setupUI() {
        view.backgroundColor = DesignSystem.Color.primaryBg().value
        titleLabel.textColor = DesignSystem.Color.primaryText().value
        subtitleLabel.textColor = DesignSystem.Color.secondaryText().value
        amountLabel.textColor = DesignSystem.Color.primaryText().value
        iconContainerView.backgroundColor = DesignSystem.Color.secondaryBg().value
        separator.backgroundColor = DesignSystem.Color.secondaryBg().value
    }
}
