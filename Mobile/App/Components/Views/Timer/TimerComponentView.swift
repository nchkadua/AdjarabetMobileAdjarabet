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
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var secondsLabel: UILabel!
    
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
    }
    
    @objc private func updateTimer() {
        initialSeconds -= 1
        timeLabel.text = String(initialSeconds)
        
        guard initialSeconds <= 0 else { return }
        
        timer?.invalidate()
        viewModel.timerDidEnd()
    }
    
    private func stopTimer() {
        timer?.invalidate()
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
        
        titleLabel.setTextColor(to: .secondaryText())
        titleLabel.setFont(to: .caption2(fontCase: .lower))
        titleLabel.text = R.string.localization.sms_resend_title.localized()
        
        secondsLabel.setTextColor(to: .primaryText())
        secondsLabel.setFont(to: .caption2(fontCase: .lower))
        secondsLabel.text = R.string.localization.sms_resend_time.localized()
        
        timeLabel.setTextColor(to: .primaryText())
        timeLabel.setFont(to: .caption2(fontCase: .lower))
    }
}
