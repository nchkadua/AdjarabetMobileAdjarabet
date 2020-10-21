//
//  NotificationContentViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class NotificationContentViewController: UIViewController {
    public var viewModel: NotificationContentViewModel!
    public lazy var navigator = NotificationContentNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: IBOutlets
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: NotificationContentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

//        viewModel.route.subscribe(onNext: { [weak self] route in
//            self?.didRecive(route: route)
//        }).disposed(by: disposeBag)
    }

    private func didRecive(action: NotificationContentViewModelOutputAction) {
        switch action {
        case .setupWith(let notification): setup(with: notification)
        }
    }

    private func didRecive(route: NotificationContentViewModelRoute) {
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .baseBg300())
        setupNavigationItem()
        setupLabels()
    }

    private func setupNavigationItem() {
        setBackBarButtonItemIfNeeded(width: 44)
        setTitle(title: viewModel.params.notification.pageTitle)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupLabels() {
        timeLabel.setFont(to: .body1)
        timeLabel.setTextColor(to: .systemWhite())

        titleLabel.font = R.font.firaGOBold(size: 20)
        titleLabel.setTextColor(to: .systemWhite())

        textLabel.setFont(to: .body1)
        textLabel.setTextColor(to: .systemWhite(alpha: 0.7))
    }

    private func setup(with notification: Notification) {
        coverImageView.image = notification.image
        timeLabel.text = notification.time ?? notification.date.stringValue
        titleLabel.text = notification.title
        textLabel.text = notification.text
    }
}
