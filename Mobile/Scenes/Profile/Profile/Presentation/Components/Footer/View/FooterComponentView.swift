//
//  FooterComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol FooterComponentViewDelegate: AnyObject {
    func languageDidChange(language: Language)
}

public class FooterComponentView: UIView {
    public weak var delegate: FooterComponentViewDelegate?

    private var disposeBag = DisposeBag()
    public var viewModel: FooterComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var legalBgView: UIView!
    @IBOutlet weak private var legalImageView: UIImageView!
    @IBOutlet weak private var legalLabel1: UILabel!
    @IBOutlet weak private var legalLabel2: UILabel!
    @IBOutlet weak private var contactButton: UIButton!
    @IBOutlet weak private var languageButton: LanguagesButton!

    public var contactUsButton: UIButton { contactButton }

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

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        legalBgView.roundCornersBezier(.allCorners, radius: 46)
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didChangeLanguage:
                self?.setupUI()
            case .setBackgroundColor(let color):
                self?.set(backgroundColor: color)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    func set(backgroundColor color: DesignSystem.Color) {
        view.backgroundColor = color.value
    }

    private func setupLegalView() {
        legalBgView.backgroundColor = .clear

        legalLabel1.setTextColor(to: .primaryText())
        legalLabel1.setFont(to: .caption2(fontCase: .lower, fontStyle: .semiBold))
        legalLabel1.numberOfLines = 1
        legalLabel1.setTextWithAnimation(R.string.localization.login_legal1.localized())

        legalLabel2.setTextColor(to: .secondaryText())
        legalLabel2.setFont(to: .caption1(fontCase: .lower, fontStyle: .regular))
        legalLabel2.numberOfLines = 1
        legalLabel2.setTextWithAnimation(R.string.localization.login_legal2.localized())

        legalImageView.image = R.image.login.legal()
        legalImageView.setTintColor(to: .primaryText())
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
        view.setBackgorundColor(to: .thick())

        setupLegalView()
        setDelegates()
    }
}

// MARK: Appium
extension FooterComponentView {
    func setAccessibilityIdToLAnguageButton(_ id: String) {
        languageButton.accessibilityIdentifier = "FooterComponentView.languageButton"
        contactButton.accessibilityIdentifier = "FooterComponentView.contactButton"
    }
}
