//
//  CloseAccountViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class CloseAccountViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: CloseAccountViewModel
    public lazy var navigator = CloseAccountNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var popup: UIView!
    @IBOutlet private weak var popupTitleLabel: UILabel!
    @IBOutlet private weak var popupDescriptionLabel: UILabel!
    @IBOutlet private weak var popupCloseButton: UIButton!

    @IBOutlet private weak var backgroundView: UIView!

    @IBOutlet private weak var hideConstraint: NSLayoutConstraint!
    @IBOutlet private weak var showConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundAction))
        backgroundView.addGestureRecognizer(tap)

        DispatchQueue.main.async {
            UIView.transition(
                with: self.popup,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                    self.hideConstraint.priority = .defaultLow
                    self.showConstraint.priority = .defaultHigh
                }
            )
        }

        // setup popup UI
        popupTitleLabel.setFont(to: .body2(fontCase: .lower, fontStyle: .semiBold))
        popupDescriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        popupCloseButton.setFont(to: .callout(fontCase: .lower, fontStyle: .bold))
        popupCloseButton.layer.borderColor = DesignSystem.Color.primaryText().value.cgColor

        // setup popup texts
        popupTitleLabel.text = R.string.localization.close_account_title.localized()
        popupDescriptionLabel.text = R.string.localization.close_account_description.localized()
        popupCloseButton.setTitleWithoutAnimation(R.string.localization.close_account_close_button_title.localized(), for: .normal)
    }

    @objc private func backgroundAction() {
        close()
    }

    @IBAction func phone1Tapped() {
        guard let number = URL(string: "tel://+995322711010") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }

    @IBAction func phone2Tapped() {
        guard let number = URL(string: "tel://+995322971010") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }

    @IBAction func closeTapped() {
        close()
    }

    private func close() {
        UIView.transition(
            with: self.popup,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let self = self else { return }
                self.view.backgroundColor = .clear
                self.hideConstraint.priority = .defaultHigh
                self.showConstraint.priority = .defaultLow
            },
            completion: { [weak self] _ in
                self?.dismiss(animated: false, completion: nil)
            }
        )
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: CloseAccountViewModel) {
        /*viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CloseAccountViewModelOutputAction) {
    }

    private func didRecive(route: CloseAccountViewModelRoute) {*/
    }
}
