//
//  DocumentationActionComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class DocumentationActionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: DocumentationActionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var separator: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: DocumentationActionComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title): self?.setupUI(title: title)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String) {
        titleLabel.text = title
    }
}

extension DocumentationActionComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())
        separator.setBackgorundColor(to: .secondaryBg())

        iconImageView.setTintColor(to: .primaryText())

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
    }
}
