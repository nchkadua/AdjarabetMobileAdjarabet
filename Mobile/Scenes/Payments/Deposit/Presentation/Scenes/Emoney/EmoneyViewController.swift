//
//  EmoneyViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class EmoneyViewController: UIViewController {
    @Inject(from: .viewModels) var viewModel: EmoneyViewModel
    private lazy var navigator = EmoneyNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: Outlets
    @IBOutlet weak private var titleStackView: UIStackView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var emoneyButton: EmoneyButton!
    @IBOutlet weak private var instructionsView: UIView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: EmoneyViewModel) {
        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(route: EmoneyViewModelRoute) {
        switch route {
        case .navigate(let params):
            navigator.navigate(to: .webView(with: params))
        }
    }

    // MARK: Setup methods
    private func setup() {
        titleStackView.setBackgorundColor(to: .tertiaryBg())
        titleStackView.layer.cornerRadius = 4

        titleLabel.numberOfLines = 3
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))
        titleLabel.text = R.string.localization.emoney_title.localized()
    }

    // MARK: Action methods
    @IBAction func navigateTapped() {
        viewModel.navigate()
    }
}
