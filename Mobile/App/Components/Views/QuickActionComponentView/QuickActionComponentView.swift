//
//  QuickActionComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class QuickActionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: QuickActionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var arrowImageView: UIImageView!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: QuickActionComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let icon, let title, let hide):
                self?.setupUI(icon: icon, title: title, hideSeparator: hide)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(icon: UIImage, title: String, hideSeparator: Bool) {
        iconImageView.image = icon
        titleLabel.text = title
        separatorView.isHidden = hideSeparator
    }
}

extension QuickActionComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.baseBg300().value
        separatorView.setBackgorundColor(to: DesignSystem.Color.separator())

        arrowImageView.setTintColor(to: .systemWhite())

        titleLabel.setTextColor(to: .systemWhite())
        titleLabel.setFont(to: .h3(fontCase: .lower))
    }
}