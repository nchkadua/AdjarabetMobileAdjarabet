//
//  MyCardComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class MyCardComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: MyCardComponentViewModel!
    private let cardDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM / YYYY"
        return formatter
    }()

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var upperContainerView: UIView!
    @IBOutlet weak private var lowerContainerView: UIView!
    @IBOutlet weak private var bankImageView: UIImageView!
    @IBOutlet weak private var bankAliasLbl: UILabel!
    @IBOutlet weak private var dateAddedTitleLbl: UILabel!
    @IBOutlet weak private var dateAddedLbl: UILabel!
    @IBOutlet weak private var cardNumberLbl: UILabel!
    @IBOutlet weak private var issuerImageView: UIImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(.allCorners, radius: 10)
    }

    public func setAndBind(viewModel: MyCardComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .set(let bankIcon, let bankAlias, let dateAdded, let cardNumber, let issuerIcon):
                self.set(bankIcon, bankAlias, dateAdded, cardNumber, issuerIcon)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
    private func set(_ bankIcon: UIImage?,
                     _ bankAlias: String,
                     _ dateAdded: Date,
                     _ cardNumber: String,
                     _ issuerIcon: UIImage?) {
        bankImageView.image = bankIcon
        bankAliasLbl.text = bankAlias
        cardNumberLbl.text = formatCardNumber(cardNumber)
        issuerImageView.image = issuerIcon
        dateAddedLbl.text = cardDateFormatter.string(from: dateAdded)
    }

    private func formatCardNumber(_ number: String) -> String {
        return number.replacingOccurrences(of: "[*x]", with: "•", options: .regularExpression, range: nil)
    }
}

extension MyCardComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .primaryBg())
        upperContainerView.setBackgorundColor(to: .secondaryBg())
        lowerContainerView.setBackgorundColor(to: .tertiaryBg())
        dateAddedTitleLbl.setTextColor(to: .secondaryText())
        dateAddedTitleLbl.setFont(to: .caption2(fontCase: .lower))
        dateAddedLbl.setTextColor(to: .primaryText())
        dateAddedLbl.setFont(to: .footnote(fontCase: .lower, fontStyle: .bold))
        bankAliasLbl.setTextColor(to: .primaryText())
        bankAliasLbl.setFont(to: .footnote(fontCase: .lower, fontStyle: .bold))
        cardNumberLbl.setTextColor(to: .primaryText())
        cardNumberLbl.setFont(to: .footnote(fontCase: .upper, fontStyle: .semiBold))
        cardNumberLbl.letterSpace = 2
    }
}
