//
//  AddMyCardComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class AddMyCardComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AddMyCardComponentViewModel!
    @IBOutlet weak private var addCardLbl: UILabel!
    @IBOutlet weak private var addCardImageView: UIImageView!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!

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
        roundCorners(radius: 10)
    }

    public func setAndBind(viewModel: AddMyCardComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel.didBind()
    }
}

extension AddMyCardComponentView: Xibable {
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
        addCardLbl.setTextColor(to: .primaryText())
        addCardLbl.setFont(to: .subHeadline(fontCase: .lower))
        addCardLbl.text = R.string.localization.my_cards_add_card()
        addCardImageView.image = R.image.myCards.addCard()
    }
}
