//
//  WebViewHeaderComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 28.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class WebViewHeaderComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: WebViewHeaderComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak private var forwardButton: UIButton!
    @IBOutlet weak private var reloadButton: UIButton!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: WebViewHeaderComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setupWith(let title, let navigation): self?.set(title, navigation)
            case .activateBackButton:
                self?.backButton.alpha = 1.0
                self?.backButton.isUserInteractionEnabled = true
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(_ title: String, _ navigation: Bool) {
        titleLabel.text = title

        backButton.isHidden = !navigation
        forwardButton.isHidden = !navigation
        reloadButton.isHidden = !navigation
    }

    @objc private func dismiss() {
        viewModel.dismiss()
    }

    @objc private func goBack() {
        viewModel.goBack()

        forwardButton.alpha = 1.0
        forwardButton.isUserInteractionEnabled = true
    }

    @objc private func goForward() {
        viewModel.goForward()
    }

    @objc private func refresh() {
        viewModel.reload()
    }
}

extension WebViewHeaderComponentView: Xibable {
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

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = "www.adjarabet.com"

        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.isHidden = true

        forwardButton.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        forwardButton.isHidden = true

        reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        reloadButton.isHidden = true
    }
}
