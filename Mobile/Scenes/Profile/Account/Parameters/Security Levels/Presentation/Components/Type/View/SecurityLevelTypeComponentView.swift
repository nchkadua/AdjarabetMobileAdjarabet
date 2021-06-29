//
//  SecurityLevelTypeComponentView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class SecurityLevelTypeComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: SecurityLevelTypeComponentViewModel!

    private var isChecked = false {
        didSet {
            let image: UIImage
            if isChecked {
                image = R.image.securityLevels.verifyOption()!.withRenderingMode(.alwaysOriginal)
                checkboxHeight.constant = 32
            } else {
                image = R.image.securityLevels.oval()!.withRenderingMode(.alwaysOriginal)
                checkboxHeight.constant = 30
            }
            checkbox.image = image
        }
    }

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var checkbox: UIImageView!
    @IBOutlet private weak var checkboxHeight: NSLayoutConstraint!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: SecurityLevelTypeComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let model):
                self?.label.text = model.title
                self?.isChecked  = model.selected
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
}

extension SecurityLevelTypeComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = .clear
        label.setTextColor(to: .primaryText())
        label.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
    }
}
