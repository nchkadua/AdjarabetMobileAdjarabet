//
//  ActiveMyBonusesHeaderComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class ActiveMyBonusesHeaderComponentView: UIView {
	typealias ViewModel = ActiveMyBonusesHeaderComponentViewModel

    private var disposeBag = DisposeBag()
    private var viewModel: ActiveMyBonusesHeaderComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!

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
		configure(with: viewModel)
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

	// MARK: - Configure

	private func configure(with viewModel: ViewModel) {
		configure(title: viewModel.title)
		configure(count: viewModel.count)
	}

	private func configure(title: String) {
		titleLabel.text = title
	}

	private func configure(count: Int) {
		countLabel.text = "\(count)"
	}
}

extension ActiveMyBonusesHeaderComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
    }
}
