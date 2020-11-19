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

    private func setup() {
        layoutConfirmButton()

        setBaseBackgorundColor(to: .secondaryBg())
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
}
