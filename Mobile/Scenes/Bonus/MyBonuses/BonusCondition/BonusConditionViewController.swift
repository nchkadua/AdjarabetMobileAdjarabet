//
//  BonusConditionViewController.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 04.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BonusConditionDelegate: AnyObject {
	func closeButtonTapped()
}

public class BonusConditionViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: BonusConditionViewModel
    public lazy var navigator = BonusConditionNavigator(viewController: self)
    private let disposeBag = DisposeBag()

	public var delegate: BonusConditionDelegate?

	// MARK: - Outlets
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var closeButton: UIButton!
	@IBOutlet weak private var descriptionLabel: UILabel!
	@IBOutlet weak private var playNowButton: UIButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
		setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

	// MARK: - Setup
	private func setup() {
		setupTitleLabel()
		setupCloseButton()
		setupDescriptionLabel()
		setupPlayNowButton()
	}

	private func setupTitleLabel() {
		titleLabel.text = R.string.localization.my_bonuses_condition_title.localized()
	}

	private func setupCloseButton() {
		closeButton.setTitle(R.string.localization.my_bonuses_condition_close.localized(), for: .normal)
	}

	private func setupDescriptionLabel() {
		descriptionLabel.text = viewModel.description
	}

	private func setupPlayNowButton() {
		playNowButton.setTitle(R.string.localization.my_bonuses_play_now.localized(), for: .normal)
	}

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: BonusConditionViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: BonusConditionViewModelOutputAction) {
    }

    private func didRecive(route: BonusConditionViewModelRoute) {
    }

	@IBAction func closeButtonTapHandler(_ sender: Any) {
		delegate?.closeButtonTapped()
	}

	@IBAction func playNowButtonTapHandler(_ sender: Any) {
		// TODO
	}
}

// MARK: - UIViewControllerTransitioningDelegate
extension BonusConditionViewController: UIViewControllerTransitioningDelegate {
	public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		ABPopupPresentationController(
			presentedViewController: presented,
			presenting: presenting,
			params: .init(
				heightConstant: 275
			)
		)
	}
}
