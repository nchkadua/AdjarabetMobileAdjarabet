//
//  ActiveMyBonusItemComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class ActiveMyBonusItemComponentView: UIView {
	typealias ViewModel = ActiveMyBonusItemComponentViewModel

    private var disposeBag = DisposeBag()
    private var viewModel: ViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
	@IBOutlet weak private var dateLabel: UILabel!
	@IBOutlet weak private var nameLabel: UILabel!
	@IBOutlet weak private var playNowButton: UIButton!
	@IBOutlet weak private var conditionButton: UIButton!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: ViewModel) {
        self.viewModel = viewModel
		setup()
		configure(with: viewModel)
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
			guard let self = self else { return }
            switch action {
			case .hideConditionButton:
				self.conditionButton.hide()
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

	private func setup() {
		setupPlayNowButton()
	}

	private func setupPlayNowButton() {
		playNowButton.setTitle(viewModel.playNowButtonTitle, for: .normal)
	}

	// MARK: - Configure

	public func configure(with viewModel: ViewModel) {
		configure(date: viewModel.date)
		configure(name: viewModel.name)
	}

	private func configure(date: String) {
		dateLabel.text = date
	}

	private func configure(name: String) {
		nameLabel.text = name
	}

	// MARK: - Actions

	@IBAction func playNowButtonHandler(_ sender: Any) {
		viewModel.playNowButtonClicked()
	}
	@IBAction func hintButtonHandler(_ sender: Any) {
		viewModel.hintButtonClicked()
	}
}

extension ActiveMyBonusItemComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() { }
}
