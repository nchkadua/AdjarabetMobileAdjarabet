//
//  FAQQuestionComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class FAQQuestionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: FAQQuestionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var separator: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: FAQQuestionComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title): self?.setTitle(title)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension FAQQuestionComponentView: Xibable {
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
        separator.setBackgorundColor(to: .opaque())

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        titleLabel.setTextColor(to: .primaryText())
    }
}
