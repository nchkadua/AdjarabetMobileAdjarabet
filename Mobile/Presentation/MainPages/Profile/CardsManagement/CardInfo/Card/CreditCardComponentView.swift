//
//  CardComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class CreditCardComponentView: UIView {
    enum CardSide {
        case front
        case back
    }

    private var disposeBag = DisposeBag()
    private var viewModel: CreditCardComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var creditCardBgImageView: UIImageView!
    // Front
    @IBOutlet weak private var frontView: UIView!
    @IBOutlet weak private var cardNumberBgView: UIView!
    @IBOutlet weak private var cardNumberLabel: UILabel!
    @IBOutlet weak private var usageDateBgView: UIView!
    @IBOutlet weak private var usageDateTitleLabel: UILabel!
    @IBOutlet weak private var usageDateLabel: UILabel!
    // Back
    @IBOutlet weak private var backView: UIView!
    @IBOutlet weak private var cvvLabel: UILabel!

    private var cardSide: CardSide = .front

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        styleBgViews()
    }

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: CreditCardComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setCardNumber(let cardNumber): self?.setCardNumber(cardNumber)
            case .setUsageDate(month: let month, year: let year): self?.setUsageDate(month: month, year: year)
            case .setCVV(let cvv): self?.setCVV(cvv)
            case .focusOn(let inputView): self?.focusOn(inputView)
            }
        }).disposed(by: disposeBag)
    }

    // MARK: Private methods
    private func styleBgViews() {
        cardNumberBgView.layer.cornerRadius = 10
        cardNumberBgView.layer.borderWidth = 1
        cardNumberBgView.layer.borderColor = UIColor.clear.cgColor

        usageDateBgView.layer.cornerRadius = 10
        usageDateBgView.layer.borderWidth = 1
        usageDateBgView.layer.borderColor = UIColor.clear.cgColor
    }

    private func setCardNumber(_ cardNumber: String) {
        makeCardNumberBorderVisible(false)
        guard cardNumberLabel.text != cardNumber.unfoldSubSequences(limitedTo: 4).joined(separator: "    ") else { return }
        guard !cardNumber.isEmpty else { return }

        cardNumberLabel.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { [self] in
            let number = cardNumber.unfoldSubSequences(limitedTo: 4).joined(separator: "    ")
            cardNumberLabel.pushTransition(0.2)
            cardNumberLabel.text = number
        })
    }

    private func setUsageDate(month: String, year: String) {
        makeUsageDateBorderVisible(false)
        guard usageDateLabel.text != "\(month)\("/")\(year)" else { return }
        guard !"\(month) \(year)".isEmpty else { return }

        usageDateLabel.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { [self] in
            usageDateLabel.pushTransition(0.2)
            usageDateLabel.text = "\(month)\("/")\(year)"
        })
    }

    private func setCVV(_ cvv: String) {
        guard cvvLabel.text != cvv else { return }

        guard !cvv.isEmpty else { return }
        cvvLabel.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: { [self] in
            cvvLabel.pushTransition(0.2)
            cvvLabel.text = cvv
        })
    }

    private func focusOn(_ inputView: InputView) {
        switch inputView {
        case .cardNumber:
            flipToFront()
            makeCardNumberBorderVisible(true)
            makeUsageDateBorderVisible(false)
        case .usageDate:
            flipToFront()
            makeUsageDateBorderVisible(true)
            makeCardNumberBorderVisible(false)
        case .CVV:
            flipToBack()
        }
    }

    // MARK: View Animation
    private func makeCardNumberBorderVisible(_ visible: Bool) {
        let borderColor: UIColor = visible ? DesignSystem.Color.systemYellow().value : UIColor.clear
        cardNumberBgView.animateBorderColor(toColor: borderColor, duration: 0.1)
    }

    private func makeUsageDateBorderVisible(_ visible: Bool) {
        let borderColor: UIColor = visible ? DesignSystem.Color.systemYellow().value : UIColor.clear
        usageDateBgView.animateBorderColor(toColor: borderColor, duration: 0.1)
    }

    private func flipToFront() {
        guard cardSide == .back else { return }

        UIView.transition(with: creditCardBgImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.backView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                self.frontView.isHidden = false
            })
            self.creditCardBgImageView.image = R.image.cardManagement.card_front()
        }, completion: {_ in
            self.cardSide = .front
        })
    }

    private func flipToBack() {
        guard cardSide == .front else { return }

        UIView.transition(with: creditCardBgImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.frontView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                self.backView.isHidden = false
            })
            self.creditCardBgImageView.image = R.image.cardManagement.card_back()
        }, completion: {_ in
            self.cardSide = .back
        })
    }
}

extension CreditCardComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        roundCorners(.allCorners, radius: 10)
        creditCardBgImageView.image = R.image.cardManagement.card_front()
        setupFrontView()
        frontView.isHidden = false
        setupBackView()
        backView.isHidden = true
    }

    func setupFrontView() {
        cardNumberLabel.setFont(to: .title3(fontCase: .upper, fontStyle: .bold))
        cardNumberLabel.setTintColor(to: .primaryText())
        cardNumberLabel.text = "____    ____    ____    ____"

        usageDateTitleLabel.setFont(to: .caption2(fontCase: .lower))
        usageDateTitleLabel.setTextColor(to: .primaryText())
        usageDateTitleLabel.text = R.string.localization.card_usage_date_title.localized()

        usageDateLabel.setFont(to: .subHeadline(fontCase: .upper, fontStyle: .bold))
        usageDateLabel.setTextColor(to: .primaryText())
        usageDateLabel.text = "--/--"
    }

    func setupBackView() {
        cvvLabel.setFont(to: .subHeadline(fontCase: .upper, fontStyle: .bold))
        cvvLabel.setTextColor(to: .systemGrey())
    }
}
