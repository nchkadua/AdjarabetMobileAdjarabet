//
//  EndedMyBonusItemComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class EndedMyBonusItemComponentView: UIView {
	typealias ViewModel = EndedMyBonusItemComponentViewModel

    private var disposeBag = DisposeBag()
    private var viewModel: ViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
	@IBOutlet weak private var startDateLabel: UILabel!
	@IBOutlet weak private var endDateLabel: UILabel!
	@IBOutlet weak private var nameLabel: UILabel!
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
		print("*** set and bind")
        self.viewModel = viewModel
		configure(with: viewModel)
        bind()
    }

    private func bind() {
		print("*** bind")
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
			guard let self = self else { return }
			switch action {
				case .hideHintButton:
					self.conditionButton.hide()
				case .hideEndDate:
					self.endDateLabel.hide()
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

	// MARK: - Configure

	public func configure(with viewModel: ViewModel) {
		configure(startDate: viewModel.startDate)
		configure(endDate: viewModel.endDate)
		configure(name: viewModel.name)
		configureConditionButton()
	}

	private func configure(startDate: String) {
		startDateLabel.text = startDate
	}

	private func configure(endDate: String) {
		endDateLabel.text = endDate
		if endDate.isEmpty { // TODO: replace by viewModel initing
			endDateLabel.hide()
		}
	}

	private func configure(name: String) {
		nameLabel.text = name
	}

	private func configureConditionButton() {
		if viewModel.condition.isEmpty { // TODO change bt viewModel initing
			conditionButton.hide()
		}
	}

	@IBAction func hintButtonClicked(_ sender: Any) {
		viewModel.delegate?.hintButtonClicked(description: viewModel.condition, gameId: viewModel.gameId)
	}
}

extension EndedMyBonusItemComponentView: Xibable {
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
