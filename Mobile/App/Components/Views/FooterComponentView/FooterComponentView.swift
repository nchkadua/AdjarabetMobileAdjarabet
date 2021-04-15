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
    @IBOutlet weak private var legalBgView: UIView!
    @IBOutlet weak private var legalImageView: UIImageView!
    @IBOutlet weak private var legalLabel: UILabel!
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

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        legalBgView.roundCorners(.allCorners, radius: 46)
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
        legalBgView.setBackgorundColor(to: .tertiaryBg())

        legalLabel.setTextColor(to: .primaryText())
        legalLabel.setFont(to: .caption2(fontCase: .lower, fontStyle: .regular))
        legalLabel.numberOfLines = 3
        legalLabel.setTextWithAnimation(R.string.localization.login_legal.localized())

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
        view.backgroundColor = DesignSystem.Color.secondaryBg().value

        setupLegalView()
        setDelegates()
    }
}

// MARK: Appium
extension FooterComponentView {
    public func setAccessibilityIdToLAnguageButton(_ id: String) {
        languageButton.accessibilityIdentifier = id
    }
}
