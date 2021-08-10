//
//  BiometricSettingsViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class BiometricSettingsViewController: ABPopupViewController {
    @Inject(from: .viewModels) var viewModel: BiometricSettingsViewModel
    public lazy var navigator = BiometricSettingsNavigator(viewController: self)

    private lazy var settingsAllert: UIAlertController = {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: R.string.localization.settings.localized(), style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        alert.addAction(UIAlertAction(title: R.string.localization.cancel.localized(), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        return alert
    }()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var toggle: UISwitch!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setup()
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    private func setup() {
        view.setBackgorundColor(to: .secondaryBg())

        viewModel.refreshTitleText() // to update titleLabel.text
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .callout(fontCase: .upper, fontStyle: .regular))

        viewModel.refreshIconImage() // to update iconImageView.image
        iconImageView.setTintColor(to: .primaryText())

        viewModel.refreshDescriptionText() // to update descriptionLabel.text
        descriptionLabel.setTextColor(to: .primaryText())
        descriptionLabel.setFont(to: .callout(fontCase: .upper, fontStyle: .bold))

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
        case .openSettingsAlert(let title, let message):
            settingsAllert.title   = title
            settingsAllert.message = message
            present(settingsAllert, animated: true, completion: nil)
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
                heightConstant: 240
            )
        )
    }
}
