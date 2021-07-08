//
//  LogOutComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class LogOutComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: LogOutComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var button: ABButton!

    override func layoutSubviews() {
        super.layoutSubviews()
        button.roundCorners(radius: 12)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: LogOutComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title): self?.setupUI(title: title)
            case .endLoading: self?.button.set(isLoading: false)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String) {
        button.setTitle(title, for: .normal)
        button.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        button.setTitleColor(to: .primaryText(), for: .normal)
        button.setBackgorundColor(to: .systemGrey5())
        button.roundCorners(radius: 12)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton() {
        button.set(isLoading: true)
        viewModel.didTapButton()
    }
}

extension LogOutComponentView: Xibable {
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
    }
}
