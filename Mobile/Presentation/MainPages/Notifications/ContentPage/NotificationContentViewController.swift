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
    @IBOutlet weak private var playButton: ABButton!

    private var urlString = ""

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
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
        case .setTime(let time): timeLabel.text = time
        case .showMessage(let message): showAlert(title: message)
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItem()
        setupLabels()
        setupButton()
    }

    private func setupNavigationItem() {
        setBackBarButtonItemIfNeeded(width: 35, height: 35, rounded: true)
        setTitle(title: viewModel.params.notification.header)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupLabels() {
        timeLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        timeLabel.setTextColor(to: .primaryText())

        titleLabel.setFont(to: .title3(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())

        textLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        textLabel.setTextColor(to: .secondaryText())
    }

    private func setupButton() {
        playButton.setStyle(to: .primary(state: .active, size: .large))
        playButton.setTitleWithoutAnimation(R.string.localization.notifications_play_button_title.localized(), for: .normal)
        playButton.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        playButton.isHidden = false
    }

    private func setup(with notification: NotificationItemsEntity.NotificationEntity) {
        viewModel.calculateTimeOf(notification)
        titleLabel.text = notification.header
        splitContent(notification.content)
    }

    private func splitContent(_ content: String) {
        let array = content.components(separatedBy: "https")
        guard !array.isEmpty else {
            playButton.isHidden = true
            return
        }

        textLabel.text = array[0]
        urlString = "\("https")\(array[1])"
    }

    // MARK: Action methods
    @objc private func openUrl() {
        viewModel.openUrl(urlString)
    }
}
