//
//  ResetOptionComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class ResetOptionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: ResetOptionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var separator: UIView!
    @IBOutlet weak private var bgView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: ResetOptionComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCornersBezier(viewModel.params.roundCorners, radius: 4)
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setupUI(let title, let roundCorners, let hidesSeparator, let isDisabled):
                self?.setupUI(title: title ?? "", roundCorners: roundCorners, hidesSeparator: hidesSeparator, isDisabled: isDisabled)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String, roundCorners: UIRectCorner, hidesSeparator: Bool, isDisabled: Bool) {
        if !title.isEmpty {
            titleLabel.text = title
        }
        separator.isHidden = hidesSeparator
        isDisabled ? titleLabel.setTextColor(to: .tertiaryText()) : titleLabel.setTextColor(to: .primaryText())
        isUserInteractionEnabled = !isDisabled
    }

    // MARK: Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bgView.backgroundColor = DesignSystem.Color.querternaryBg().value
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        bgView.backgroundColor = DesignSystem.Color.tertiaryBg().value
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        bgView.backgroundColor = DesignSystem.Color.tertiaryBg().value
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        bgView.backgroundColor = DesignSystem.Color.tertiaryBg().value
    }
}

extension ResetOptionComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())
        separator.setBackgorundColor(to: .systemGrey3())

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
    }
}
