//
//  BiometricSettingsViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class BiometricSettingsViewController: ABPopupViewController {
    @Inject(from: .viewModels) public var viewModel: BiometricSettingsViewModel
    public lazy var navigator = BiometricSettingsNavigator(viewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var toggle: UISwitch!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setup()
        viewModel.viewDidLoad()
    }

    private func setup() {
        view.setBackgorundColor(to: .tertiaryBg())

        viewModel.refreshTitleText() // to update titleLabel.text
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))

        viewModel.refreshIconImage() // to update iconImageView.image
        iconImageView.setTintColor(to: .primaryText())

        viewModel.refreshDescriptionText() // to update descriptionLabel.text
        descriptionLabel.setTextColor(to: .primaryText())
        descriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .semiBold))

        toggle.onTintColor = DesignSystem.Color.primaryRedNeutral().value
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: BiometricSettingsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: BiometricSettingsViewModelOutputAction) {
        switch action {
        case .updateTitleText(let title):              titleLabel.text = title
        case .updateDescriptionText(let description):  descriptionLabel.text = description
        case .updateIconImage(let icon):               iconImageView.image = icon
        case .updateBiometryStateToggle(let on):       toggle.isOn = on
        }
    }

    private func didRecive(route: BiometricSettingsViewModelRoute) {
        switch route {
        case .openAlert(let title, _): showAlert(title: title)
        }
    }

    @IBAction private func biometryToggleChanged(sender: UISwitch) {
        viewModel.biometryToggleChanged(to: sender.isOn)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BiometricSettingsViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ABPopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            params: .init(
                heightConstant: 177
            )
        )
    }
}
