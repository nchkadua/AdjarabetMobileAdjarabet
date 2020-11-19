//
//  P2PTransferViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class P2PTransferViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: P2PTransferViewModel
    public lazy var navigator = P2PTransferNavigator(viewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var personIdInputView: ABInputView!
    @IBOutlet private weak var transferAmountInputView: ABInputView!
    @IBOutlet private weak var commissionAmountLabelView: LabelComponentView!
    @IBOutlet private weak var labelViewSeparator: UIView!
    @IBOutlet private weak var totalAmountLabelView: LabelComponentView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var statusIconImageView: UIImageView!
    @IBOutlet private weak var personNameLabel: UILabel!
    private var confirmButton = ABButton()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: P2PTransferViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: P2PTransferViewModelOutputAction) {
    }

    private func didRecive(route: P2PTransferViewModelRoute) {
    }

    private func setup() {
        layoutConfirmButton()
        setBaseBackgorundColor()
        setupTitleLabel()
        setupInputViews()
        setupLabelViews()
        setupConfirmButton()
    }

    private func setupTitleLabel() {
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.text = R.string.localization.p2p_transfer_p2p_transfer.localized()
    }

    private func setupInputViews() {
        personIdInputView.setupWith(backgroundColor: .secondaryFill(), borderWidth: 0)
        personIdInputView.setPlaceholder(text: R.string.localization.p2p_transfer_friend_id.localized())

        transferAmountInputView.setupWith(backgroundColor: .secondaryFill(), borderWidth: 0)
        transferAmountInputView.setPlaceholder(text: R.string.localization.p2p_transfer_tranfer_amount.localized())
    }

    private func setupLabelViews() {
        commissionAmountLabelView.set(backgroundColor: .systemGrey5())
        commissionAmountLabelView.mainView.roundCorners([.topLeft, .topRight], radius: 8)
        commissionAmountLabelView.set(label: .init(title: R.string.localization.p2p_transfer_transaction_commission.localized(), value: ""))

        labelViewSeparator.setBackgorundColor(to: .nonOpaque())

        totalAmountLabelView.set(backgroundColor: .systemGrey5())
        totalAmountLabelView.mainView.roundCorners([.bottomLeft, .bottomRight], radius: 8)
        totalAmountLabelView.set(label: .init(title: R.string.localization.p2p_transfer_total_amount.localized(), value: ""))
    }

    private func setupConfirmButton() {
        confirmButton.setStyle(to: .tertiary(state: .acvite, size: .large))
        confirmButton.setTitleWithoutAnimation(R.string.localization.p2p_transfer_confirm.localized(), for: .normal)
    }

    private func layoutConfirmButton() {
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: totalAmountLabelView.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: totalAmountLabelView.trailingAnchor),
            confirmButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 22),
            confirmButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}
