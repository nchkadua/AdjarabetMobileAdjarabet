//
//  TimerComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class TimerComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: TimerComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var secondsLabel: UILabel!
    @IBOutlet weak private var resendButton: UIButton!

    public var button: UIButton { resendButton }
    @IBOutlet weak private var resendButtonConstraint: NSLayoutConstraint!

    private var initialSeconds = 0
    private var timer: Timer?

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: TimerComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .startFrom(let seconds): self?.startTimer(from: seconds)
            case .stopTimer: self?.stopTimer()
            case .setAdditionalConstraint(let constraint): self?.setAdditionalConstraint(constraint)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func startTimer(from seconds: Int) {
        initialSeconds = seconds
        timeLabel.text = String(initialSeconds)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateResendButton(false)
    }

    @objc private func updateTimer() {
        initialSeconds -= 1
        timeLabel.text = String(initialSeconds)

        guard initialSeconds <= 0 else { return }

        timer?.invalidate()
        viewModel.timerDidEnd()
        updateResendButton(true)
    }

    private func stopTimer() {
        timer?.invalidate()
    }

    private func updateResendButton(_ activate: Bool) {
        resendButton.isUserInteractionEnabled = activate

        secondsLabel.isUserInteractionEnabled = activate
        timeLabel.isUserInteractionEnabled = activate

        if activate {
            UIView.animate(withDuration: 0.22) { [self] in
                resendButton.setTitleColor(to: .primaryText(), for: .normal)
                resendButton.titleLabel?.setFont(to: .callout(fontCase: .lower, fontStyle: .bold))

                secondsLabel.alpha = 0.5
                timeLabel.alpha = 0.5
            }
        } else {
            UIView.animate(withDuration: 0.22) { [self] in
                resendButton.setTitleColor(to: .secondaryText(), for: .normal)
                resendButton.titleLabel?.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))

                secondsLabel.alpha = 1
                timeLabel.alpha = 1
            }
        }
    }

    private func setAdditionalConstraint(_ constraint: CGFloat) {
        resendButtonConstraint.constant += constraint
        layoutIfNeeded()
    }
}

extension TimerComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .secondaryBg())

        let title = R.string.localization.sms_resend_title.localized()
        resendButton.setTitle(title, for: .normal)
        resendButton.titleLabel?.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        updateResendButton(false)

        secondsLabel.setTextColor(to: .primaryText())
        secondsLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .bold))
        secondsLabel.text = R.string.localization.sms_resend_time.localized()

        timeLabel.setTextColor(to: .primaryText())
        timeLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .bold))
    }
}
