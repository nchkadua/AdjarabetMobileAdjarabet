//
//  SelfSuspendViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class SelfSuspendViewController: ABViewController {
    @Inject(from: .viewModels) private var viewModel: SelfSuspendViewModel
    public lazy var navigator = SelfSuspendNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var durationsInputView: ABInputView!
    @IBOutlet private weak var blockButton: ABButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contactUsButton: ContactUsButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        durationsInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: SelfSuspendViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: SelfSuspendViewModelOutputAction) {
        switch action {
        case .setupDurations(let durations): setup(durations)
        }
    }

    private func setup(_ durations: [String]) {
        durationsInputView.setupPickerView(withItems: durations)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupInputView()
        setupButtons()
        setupLabel()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.self_suspend_title.localized())
    }

    private func setupInputView() {
        durationsInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        durationsInputView.setPlaceholder(text: R.string.localization.suspend_duration.localized())
    }

    private func setupButtons() {
        blockButton.setStyle(to: .tertiary(state: .acvite, size: .large))
        blockButton.setTitleWithoutAnimation(R.string.localization.block_accound.localized(), for: .normal)
        blockButton.addTarget(self, action: #selector(blockButtonDidTap), for: .touchUpInside)

        contactUsButton.setBackgorundColor(to: .tertiaryBg())
        contactUsButton.setCornerRadius(12)
    }

    @objc private func blockButtonDidTap() {
    }

    private func setupLabel() {
        titleLabel.text = R.string.localization.suspend_subtitle.localized()
        titleLabel.setFont(to: .footnote(fontCase: .lower))
        titleLabel.setTextColor(to: .secondaryText())
    }
}
