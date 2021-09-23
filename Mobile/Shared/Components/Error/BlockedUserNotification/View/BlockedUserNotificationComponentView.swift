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
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

	public func configure(with model: ABError.Description.BlockedUserNotification) {
		iconView.image = model.icon
		descriptionLabel.text = model.description.uppercased()
		upperNoteLabel.text = model.upperNote.uppercased()
		lowerNoteLabel.text = model.lowerNote.uppercased()
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
