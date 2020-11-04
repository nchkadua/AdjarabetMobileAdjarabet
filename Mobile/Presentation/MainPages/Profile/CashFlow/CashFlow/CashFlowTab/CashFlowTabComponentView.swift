//
//  CashFlowTabComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/29/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class CashFlowTabComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: CashFlowTabComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var depositButton: UIButton!
    @IBOutlet weak private var withdrawButton: UIButton!
    @IBOutlet weak private var cursorParentView: UIView!
    @IBOutlet weak private var cursor: UIView!

    private let animationTime = 0.2

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: CashFlowTabComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didSelectButton(let index, let animate):
                self?.selectButton(at: index, animate: animate)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func selectButton(at index: Int, animate: Bool) {
        switch index {
        case 0: selectDepositButton(animate: animate)
        case 1: selectWithdrawButton(animate: animate)
        default:
            break
        }
    }

    @objc private func depositButtonAction() {
        selectDepositButton(animate: true)
        viewModel.selectButton(at: 0, animate: true)
    }

    @objc private func withdrawButtonAction() {
        selectWithdrawButton(animate: true)
        viewModel.selectButton(at: 1, animate: true)
    }

    public func selectDepositButton(animate: Bool) {
        UIView.animate(withDuration: animate ? animationTime : 0, animations: { [self] in
            depositButton.alpha = 1
            withdrawButton.alpha = 0.5
        }, completion: { [self] _ in
            moveCursorLeft(animate: animate)
        })
    }

    public func selectWithdrawButton(animate: Bool) {
        UIView.animate(withDuration: animate ? animationTime : 0, animations: { [self] in
            withdrawButton.alpha = 1
            depositButton.alpha = 0.5
        }, completion: { [self] _ in
            moveCursorRight(animate: animate)
        })
    }

    private func moveCursorLeft(animate: Bool) {
        UIView.animate(withDuration: animate ? animationTime : 0) { [self] in
            cursor.frame = CGRect(x: 0, y: cursor.frame.origin.y, width: cursor.frame.size.width, height: cursor.frame.size.height)
        }
    }

    private func moveCursorRight(animate: Bool) {
        UIView.animate(withDuration: animate ? animationTime : 0) { [self] in
            cursor.frame = CGRect(x: cursorParentView.bounds.width / 2, y: cursor.frame.origin.y, width: cursor.frame.size.width, height: cursor.frame.size.height)
        }
    }
}

extension CashFlowTabComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.systemGray100().value
        cursor.backgroundColor = DesignSystem.Color.systemRed150().value

        depositButton.setImage(R.image.components.quickAction.deposit(), for: .normal)
        depositButton.setFont(to: .h3(fontCase: .lower))
        depositButton.setTitle(R.string.localization.deposit_button_title(), for: .normal)
        depositButton.addTarget(self, action: #selector(depositButtonAction), for: .touchUpInside)
        depositButton.adjustsImageWhenHighlighted = false

        withdrawButton.setImage(R.image.components.quickAction.withdraw(), for: .normal)
        withdrawButton.setFont(to: .h3(fontCase: .lower))
        withdrawButton.setTitle(R.string.localization.withdraw_button_title(), for: .normal)
        withdrawButton.addTarget(self, action: #selector(withdrawButtonAction), for: .touchUpInside)
        withdrawButton.adjustsImageWhenHighlighted = false

        selectDepositButton(animate: false)
    }
}
