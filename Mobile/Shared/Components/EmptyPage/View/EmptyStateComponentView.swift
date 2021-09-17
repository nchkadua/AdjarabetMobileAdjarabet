//
//  EmptyPageComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class EmptyStateComponentView: UIView {
    // MARK: Properties
    private var disposeBag = DisposeBag()
    private var viewModel: EmptyStateComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentViewCenterYConstraint: NSLayoutConstraint!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: EmptyStateComponentViewModel) {
		print("*** EmptyStateComponentView: setAndBind")
        self.viewModel = viewModel

        iconImageView.image = viewModel.params.icon
        titleLabel.text = viewModel.params.title
        descriptionLabel.text = viewModel.params.description
        setPosition(viewModel.params.position)

        bind()
    }

    private func setPosition(_ position: EmptyStatePosition) {
        switch viewModel.params.position {
        case .centered: break
        case .centeredWithBottomSpace(let space): contentViewCenterYConstraint.constant = space/(-2.0)
        }
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
			case .hide: print("*** EmptyStateComponentView: hide"); self?.hide()
			case .show: print("*** EmptyStateComponentView: show"); self?.show()
			case .titleUpdate(let title): self?.titleLabel.text = title
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
}

extension EmptyStateComponentView: Xibable {
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
