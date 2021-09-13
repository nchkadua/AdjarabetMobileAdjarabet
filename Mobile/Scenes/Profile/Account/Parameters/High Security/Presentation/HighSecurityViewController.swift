//
//  HighSecurityViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class HighSecurityViewController: ABPopupViewController {
    @Inject(from: .viewModels) var viewModel: HighSecurityViewModel
    private lazy var navigator = HighSecurityNavigator(viewController: self)

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var onOffButton: UIButton!

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setup()
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    private func setup() {
        view.setBackgorundColor(to: .secondaryBg())

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.text = R.string.localization.high_security_title.localized()

        descriptionLabel.setTextColor(to: .secondaryText())
        descriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        descriptionLabel.text = R.string.localization.high_security_description.localized()

        onOffButton.setBackgorundColor(to: .tertiaryBg())
        onOffButton.titleLabel?.font = DesignSystem.Typography.callout(fontCase: .upper, fontStyle: .semiBold).description.font
        onOffButton.layer.cornerRadius = 8
    }

    @IBAction private func onOffButtonTapped() {
        viewModel.buttonTapped()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: HighSecurityViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: HighSecurityViewModelOutputAction) {
        switch action {
        case .setupView(let loaderIsHiden):
            setupView(loaderIsHiden: loaderIsHiden)
        case .setButtonState(let isOn):
            setButtonState(isOn: isOn)
        case .isLoading(let loading): loading ? startLoading() : stopLoading()
        case .close:
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }

    private func didRecive(route: HighSecurityViewModelRoute) {
        switch route {
        case .otp(let params):
            navigator.navigate(to: .otp(params: params))
        }
    }

    private func setupView(loaderIsHiden: Bool) {
        contentView.isHidden = !loaderIsHiden
    }

    private func setButtonState(isOn: Bool) {
        if isOn {
            onOffButton.setTitleColor(.systemPink, for: .normal)
            onOffButton.setTitle(R.string.localization.high_security_button_deactivate.localized().uppercased(), for: .normal)
        } else {
            onOffButton.setTitleColor(.systemBlue, for: .normal)
            onOffButton.setTitle(R.string.localization.high_security_button_activate.localized().uppercased(), for: .normal)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HighSecurityViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ABPopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            params: .init(
                heightConstant: 280
            )
        )
    }
}
