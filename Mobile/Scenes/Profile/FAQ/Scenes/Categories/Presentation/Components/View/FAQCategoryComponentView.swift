//
//  FAQCategoryComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class FAQCategoryComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: FAQCategoryComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 6)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: FAQCategoryComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let subtitle, let icon): self?.setupUI(title: title, subTitle: subtitle, image: icon)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String, subTitle: String, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = title
        imageView.image = image
    }
}

extension FAQCategoryComponentView: Xibable {
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

        titleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())

        subtitleLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        subtitleLabel.setTextColor(to: .secondaryText())
    }
}
