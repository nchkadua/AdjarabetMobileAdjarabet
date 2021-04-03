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
    @IBOutlet weak private var greenDot: UIView!

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

    private func setupUI(with notification: Notification) {
//        iconImageView.image = notification.icon
//        titleLabel.text = notification.title
//        timeLabel.text = notification.time ?? "" // Move To ViewModel?
//        greenDot.isHidden = notification.seen
//
//        if notification.seen {
//            titleLabel.setTextColor(to: .secondaryText())
//        } else {
//            titleLabel.setTextColor(to: .primaryText())
//        }
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

        greenDot.setBackgorundColor(to: .primaryGreenNeutral())
        greenDot.layer.cornerRadius = greenDot.frame.width / 2
    }
}
