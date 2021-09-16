//
//  NotVerifiedUserViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 13.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class NotVerifiedUserViewController: ABPopupViewController {
    @Inject(from: .viewModels) public var viewModel: NotVerifiedUserViewModel
    public lazy var navigator = NotVerifiedUserNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var goToButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
        setup()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: NotVerifiedUserViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: NotVerifiedUserViewModelOutputAction) {
    }

    private func didRecive(route: NotVerifiedUserViewModelRoute) {
    }

    private func setup() {
        setupImageView()
        setupLabels()
        setupButtons()
    }

    private func setupImageView() {
        iconImageView.image = R.image.notVerified.icon()
    }

    private func setupLabels() {
        titleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.not_verified_user_title.localized()

        subtitleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        subtitleLabel.setTextColor(to: .primaryText())
        subtitleLabel.text = R.string.localization.not_verified_user_subtitle.localized()

        descriptionLabel.setFont(to: .caption1(fontCase: .lower, fontStyle: .semiBold))
        descriptionLabel.setTextColor(to: .secondaryText())
        descriptionLabel.text = R.string.localization.not_verified_user_description.localized()
    }

    private func setupButtons() {
        goToButton.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        goToButton.setTitleColor(to: .systemBlue(), for: .normal)
        goToButton.setTitle(R.string.localization.not_verified_user_goto_button_title.localized(), for: .normal)
        goToButton.semanticContentAttribute = .forceRightToLeft
        goToButton.imageEdgeInsets.left = 4

        goToButton.setBackgorundColor(to: .tertiaryBg())
        goToButton.roundCorners(radius: 18)

        goToButton.addTarget(self, action: #selector(goToVerification), for: .touchUpInside)

        dismissButton.setFont(to: .body1(fontCase: .lower, fontStyle: .regular))
        dismissButton.setTitleColor(to: .primaryText(), for: .normal)
        dismissButton.setTitle(R.string.localization.not_verified_user_dismiss_button_title.localized(), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func goToVerification() {
        showAlert(title: "Verification Page")
    }

    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension NotVerifiedUserViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ABPopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            params: .init(
                heightConstant: 500
            )
        )
    }
}
