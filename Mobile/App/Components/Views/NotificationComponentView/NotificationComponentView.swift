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
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!

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
            case .set(let notification):
                self?.setupUI(with: notification)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(with notification: NotificationItemsEntity.NotificationEntity) {
        titleLabel.text = notification.header

        let difference = minutesBetweenDates(notification.createDate.toDate, Date())
        if difference <= 59 { // 1 hour
            timeLabel.text = "\(String(Int(difference))) \(R.string.localization.notifications_minutes_ago.localized())"
        } else if difference <= 1440 { // 24 hours
            timeLabel.text = "\(String(Int(difference/60))) \(R.string.localization.notifications_hours_ago.localized())"
        } else {
            timeLabel.text = ""
        }

        if notification.status == 1 {
            titleLabel.setTextColor(to: .primaryText())
            iconImageView.image = R.image.notifications.inbox_new()
        } else if notification.status == 2 {
            titleLabel.setTextColor(to: .secondaryText())
            iconImageView.image = R.image.notifications.inbox_read()
        }
    }

    private func minutesBetweenDates(_ date1: Date, _ date2: Date) -> CGFloat {
        CGFloat(date2.timeIntervalSinceReferenceDate/60 - date1.timeIntervalSinceReferenceDate/60)
    }
}

extension NotificationComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.primaryBg().value

        titleLabel.setFont(to: .subHeadline(fontCase: .lower))
        titleLabel.setTextColor(to: .primaryText())

        timeLabel.setFont(to: .footnote(fontCase: .lower))
        timeLabel.setTextColor(to: .secondaryText())
    }
}
