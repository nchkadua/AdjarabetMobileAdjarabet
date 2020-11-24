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
    @IBOutlet private weak var subtitleLabel: UILabel!
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
        setTitle(title: R.string.localization.address_change_title.localized())
    }
    
    private func setupInputView() {
        addressInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        addressInputView.setPlaceholder(text: R.string.localization.new_address_placeholder.localized())
    }
    
    private func setupButtons() {
        approveButton.setStyle(to: .tertiary(state: .acvite, size: .large))
        approveButton.setTitleWithoutAnimation(R.string.localization.approve_address_button_title.localized(), for: .normal)
        approveButton.addTarget(self, action: #selector(approveDidTap), for: .touchUpInside)
    }
    
    @objc private func approveDidTap() {
        closeKeyboard()
    }
    
    private func setupLabel() {
        subtitleLabel.setFont(to: .caption2(fontCase: .lower))
        subtitleLabel.setTextColor(to: .primaryText())
        subtitleLabel.text = R.string.localization.new_address_subtitle.localized()
    }
}
