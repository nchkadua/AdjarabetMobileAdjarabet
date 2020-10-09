//
//  FooterComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol FooterComponentViewDelegate: class {
    func languageDidChange(language: Language)
}

public class FooterComponentView: UIView {
    public weak var delegate: FooterComponentViewDelegate?

    private var disposeBag = DisposeBag()
    public var viewModel: FooterComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var legalImageView: UIImageView!
    @IBOutlet weak private var legalTextView: LegalTextView!
    @IBOutlet weak private var contactButton: ContactUsButton!
    @IBOutlet weak private var languageButton: LanguagesButton!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    public func setAndBind(viewModel: FooterComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didChangeLanguage:
                self?.setupUI()
            case .setSeparatorViewHidden(let hidden):
                self?.setSeparatorViewHidden(hidden)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setSeparatorViewHidden(_ hidden: Bool) {
        separatorView.isHidden = hidden
    }

    private func setupLegalView() {
        separatorView.backgroundColor = R.color.colorGuide.global.separator()

        legalImageView.image = R.image.login.legal()

        legalTextView.text = R.string.localization.login_legal()
        legalTextView.setTextColor(to: .systemWhite(alpha: 0.7))
        legalTextView.setFont(to: .h6(fontCase: .lower))
        legalTextView.applyImageView(legalImageView)
    }

    private func setDelegates() {
        languageButton.delegate = self
    }
}

extension FooterComponentView: LanguagesButtonDelegate {
    func languageDidChange(language: Language) {
        delegate?.languageDidChange(language: language)
    }
}

extension FooterComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        setupLegalView()
        setDelegates()
    }
}
