//
//  NotificationComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class NotificationComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: NotificationComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: ABView!
    @IBOutlet weak private var container: UIStackView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!

    private var statusUpdated = false

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: NotificationComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let notification): self?.setupUI(with: notification)
            case .setTime(let time): self?.timeLabel.setTextWithAnimation(time)
            case .didSelect: self?.markAsRead()
            case .redraw: self?.setupWithNotification()
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(with notification: NotificationItemsEntity.NotificationEntity) {
        guard !statusUpdated else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
            titleLabel.text = notification.header
            viewModel.calculateTimeOf(notification)
            setupNotificationStatus(notification)
        }
    }

    private func setupWithNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
            titleLabel.text = viewModel.params.notification.header
            viewModel.calculateTimeOf(viewModel.params.notification)
            setupNotificationStatus(viewModel.params.notification)
        }
    }

    private func setupNotificationStatus(_ notification: NotificationItemsEntity.NotificationEntity) {
        if notification.status == 1 {
            titleLabel.setTextColor(to: .primaryText())
            iconImageView.image = R.image.notifications.inbox_new()
        } else if notification.status == 2 {
            titleLabel.setTextColor(to: .secondaryText())
            iconImageView.image = R.image.notifications.inbox_read()
        }
    }

    private func markAsRead() {
        titleLabel.setTextColor(to: .secondaryText())
        iconImageView.image = R.image.notifications.inbox_read()
        statusUpdated = true
    }
}

extension NotificationComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue as? ABView
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.primaryBg().value
        view.componentStyle = .primary

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        titleLabel.setTextColor(to: .primaryText())

        timeLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        timeLabel.setTextColor(to: .secondaryText())
    }
}
