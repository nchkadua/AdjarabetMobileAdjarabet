//
//  BlockedUserNotificationComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 23.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class BlockedUserNotificationComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: BlockedUserNotificationComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
	@IBOutlet weak private var contentView: UIView!
	@IBOutlet weak private var iconView: UIImageView!
	@IBOutlet weak private var descriptionLabel: UILabel!
	@IBOutlet weak private var upperNoteLabel: UILabel!
	@IBOutlet weak private var lowerNoteLabel: UILabel!

    @Inject(from: .useCases) private var accountRestrictionUseCase: AccountRestrictionUseCase

    private var suspendTill: Date?
    private var timer: Timer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: BlockedUserNotificationComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] _ in
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

	public func configure(with model: ABError.Description.BlockedUserNotification) {
		iconView.image = model.icon
		descriptionLabel.text = model.description.uppercased()

        configureSuspendTill()
	}

    private func configureSuspendTill() {
        accountRestrictionUseCase.getStatus { result in
            switch result {
            case .success(let restriction):
                print("*** restriction is send from viewModel")
                if let restrictionTill = restriction.until {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        if restrictionTill.isPast {
                            self.deactivateCountdownTimer()
                        } else {
                            self.upperNoteLabel.text = restrictionTill.daysLeftTexted.uppercased()
                            self.lowerNoteLabel.text = restrictionTill.clockLeftTexted.uppercased()
                        }
                    }
                } else {
                    self.deactivateCountdownTimer()
                }
            case .failure: break
            }
        }
    }

    private func deactivateCountdownTimer() {
        upperNoteLabel.text = ""
        lowerNoteLabel.text = ""
        timer?.invalidate()
    }
}

extension BlockedUserNotificationComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
//        view.backgroundColor = DesignSystem.Color.secondaryBg().value
    }
}
