//
//  ContactMailComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class ContactMailComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: ContactMailComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var mailLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: ContactMailComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setup(let title, let mail): self?.setup(title, mail)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setup(_ title: String, _ mail: String) {
        titleLabel.text = title
        mailLabel.text = mail
    }
}

extension ContactMailComponentView: Xibable {
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

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        titleLabel.setTextColor(to: .primaryText())

        mailLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        mailLabel.setTextColor(to: .secondaryText())

        imageView.image = R.image.contact.mail()?.withRenderingMode(.alwaysOriginal)
    }
}
