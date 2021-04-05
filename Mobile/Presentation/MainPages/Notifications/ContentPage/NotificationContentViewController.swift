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
    }

    private func didRecive(action: NotificationContentViewModelOutputAction) {
        switch action {
        case .setupWith(let notification): setup(with: notification)
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItem()
        setupLabels()
    }

    private func setupNavigationItem() {
        setBackBarButtonItemIfNeeded(width: 44)
        setTitle(title: viewModel.params.notification.header)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupLabels() {
        timeLabel.setFont(to: .footnote(fontCase: .lower))
        timeLabel.setTextColor(to: .primaryText())

        titleLabel.setFont(to: .title3(fontCase: .lower))
        titleLabel.setTextColor(to: .primaryText())

        textLabel.setFont(to: .footnote(fontCase: .lower))
        textLabel.setTextColor(to: .primaryText())
    }

    private func setup(with notification: NotificationItemsEntity.NotificationEntity) {
        timeLabel.text = notification.createDate.toDate.formattedStringValue
        titleLabel.text = notification.header
        textLabel.text = notification.content
    }
}
