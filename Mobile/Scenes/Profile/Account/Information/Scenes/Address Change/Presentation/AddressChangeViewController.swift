//
//  AddressChangeViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class AddressChangeViewController: ABViewController {
    @Inject(from: .viewModels) private var viewModel: AddressChangeViewModel
    public lazy var navigator = AddressChangeNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var addressInputView: ABInputView!
    @IBOutlet private weak var approveButton: ABButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addressInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AddressChangeViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AddressChangeViewModelOutputAction) {
        switch action {
        case .dismiss:
            dismiss(animated: true, completion: nil)
        case .showError(let error):
            showAlert(title: error)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupInputView()
        setupApproveButton()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.address_change_title.localized().uppercased())

        let backButtonGroup = makeBackBarButtonItem()
        navigationItem.leftBarButtonItem = backButtonGroup.barButtonItem
        backButtonGroup.button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    private func setupInputView() {
        addressInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        addressInputView.setPlaceholder(text: R.string.localization.new_address_placeholder.localized())

        Observable.combineLatest([addressInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateApproveButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func setupApproveButton() {
        approveButton.setStyle(to: .primary(state: .disabled, size: .large))
        approveButton.setTitleWithoutAnimation(R.string.localization.approve_address_button_title.localized(), for: .normal)
        approveButton.addTarget(self, action: #selector(approveDidTap), for: .touchUpInside)
    }

    @objc private func approveDidTap() {
        viewModel.approved(address: addressInputView.text ?? "")
        closeKeyboard()
    }

    // MARK: Configuration
    private func updateApproveButton(isEnabled: Bool) {
        approveButton.isUserInteractionEnabled = isEnabled
        approveButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }
}

extension AddressChangeViewController: CommonBarButtonProviding { }
