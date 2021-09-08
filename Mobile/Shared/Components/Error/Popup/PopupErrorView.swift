//
//  PopupErrorView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 8/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit
import RxSwift

class PopupErrorView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var oneButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var twoButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var popupBackgroundContentView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!

    private(set) var viewModel: PopupErrorViewModel = DefaultPopupErrorViewModel()
    private var disposeBag = DisposeBag()

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
        bind()
    }

    func setupUI() {
        popupBackgroundContentView.setBackgorundColor(to: .ultrathin())
        descriptionLabel.setFont(to: .body2(fontCase: .lower, fontStyle: .semiBold))
        button1.setFont(to: .callout(fontCase: .upper, fontStyle: .semiBold))
        button2.setFont(to: .callout(fontCase: .upper, fontStyle: .semiBold))

        descriptionLabel.setTextColor(to: .primaryText())
        button1.setTitleColor(to: .systemBlue(), for: .normal)
        button2.setTitleColor(to: .systemBlue(), for: .normal)
    }

    func setAndBind(viewModel: PopupErrorViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .configure(let model): self?.configure(from: model)
            default: break
            }
        }).disposed(by: disposeBag)
        viewModel.didBind()
    }

    func configure(from model: ABError.Description.Popup) {
        switch model.buttons.count {
        case 1:
            UIView.performWithoutAnimation {
                oneButtonConstraint.priority = .required
                twoButtonConstraint.priority = .defaultLow
            }
            button1.setTitle(model.buttons[0].value.uppercased(), for: .normal)
        case 2:
            UIView.performWithoutAnimation {
                oneButtonConstraint.priority = .defaultLow
                twoButtonConstraint.priority = .required
            }
            button1.setTitle(model.buttons[0].value.uppercased(), for: .normal)
            button2.setTitle(model.buttons[1].value.uppercased(), for: .normal)
        default:
            fatalError("Invalid number of buttons")
        }
        descriptionLabel.text = model.description
    }

    @IBAction private func button1Tapped() {
        viewModel.tapped(button: 0)
    }

    @IBAction private func button2Tapped() {
        viewModel.tapped(button: 1)
    }
}
