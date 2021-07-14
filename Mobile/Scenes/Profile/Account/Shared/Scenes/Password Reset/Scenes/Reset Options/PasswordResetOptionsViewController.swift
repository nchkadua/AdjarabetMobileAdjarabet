//
//  PasswordResetOptionsViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class PasswordResetOptionsViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: ResetOptionsViewModel
    public lazy var navigator = ResetOptionsNavigator(viewController: self)

    // MARK: - Outlets
    @IBOutlet private weak var containerView1: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var usernameInputView: ABInputView!
    @IBOutlet private weak var continueButton: ABButton!
    @IBOutlet private weak var containerView2: UIView!
    @IBOutlet private weak var container1HeighConstraint: NSLayoutConstraint!

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: ResetOptionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: ResetOptionsViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
            appTableViewController.reloadWithAnimation()
            changeContinueButtonTitle()
        case .clearTableview: clearTableView()
        case .showMessage(let message): showAlert(title: message)
        case .hideUsernameInput: container1HeighConstraint.constant = 0
        case .didClick(let resetType): print("")
        }
    }

    private func didRecive(route: ResetOptionsViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupLabel()
        setupInputView()
        setupContinueButton()
        setupTableView()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: containerView2)
        appTableViewController.setBaseBackgorundColor(to: .secondaryBg())
        appTableViewController.tableView.isScrollEnabled = false

        appTableViewController.tableView?.register(types: [
            ResetOptionTableViewCell.self
        ])
    }

    private func clearTableView() {
        var indexPathes = [IndexPath]()
        for section in 0..<appTableViewController.tableView.numberOfSections {
            for row in 0..<appTableViewController.tableView.numberOfRows(inSection: section) {
                indexPathes.append(IndexPath(row: row, section: section))
            }
        }
        appTableViewController.reloadItems(items: [], insertionIndexPathes: [], deletionIndexPathes: indexPathes)
    }

    private func setupNavigationItems() {
        let backButtonGroup = makeBackBarButtonItem(width: 60, title: R.string.localization.back_button_title.localized())
        navigationItem.leftBarButtonItem = backButtonGroup.barButtonItem
        backButtonGroup.button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    private func setupLabel() {
        titleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.password_reset_title.localized()
    }

    private func setupInputView() {
        usernameInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        usernameInputView.setPlaceholder(text: R.string.localization.reset_username_placeholder.localized())
        usernameInputView.mainTextField.delegate = self

        Observable.combineLatest([usernameInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateContinueButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func setupContinueButton() {
        continueButton.setStyle(to: .primary(state: .disabled, size: .large))
        continueButton.setTitleWithoutAnimation(R.string.localization.reset_options_button_continue.localized(), for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        continueButton.isUserInteractionEnabled = false
    }

    @objc private func continueButtonDidTap() {
        closeKeyboard()
        viewModel.buttonDidClick(usernameInputView.text ?? "")
    }

    // MARK: Configuration
    private func updateContinueButton(isEnabled: Bool) {
        continueButton.isUserInteractionEnabled = isEnabled
        continueButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    private func changeContinueButtonTitle() {
        continueButton.setTitle(R.string.localization.reset_options_button_change.localized(), for: .normal)
    }
}

extension PasswordResetOptionsViewController: CommonBarButtonProviding { }

extension PasswordResetOptionsViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && range.length > 0 {
            viewModel.clearOptions()
        }
        return true
    }
}
