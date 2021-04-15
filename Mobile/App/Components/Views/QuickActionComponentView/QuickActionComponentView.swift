//
//  QuickActionComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class QuickActionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: QuickActionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: ABView!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bgView: UIView!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: QuickActionComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let icon, let title, let hide, let roundedCorners):
                self?.setupUI(icon: icon, title: title, hideSeparator: hide, roundedCorners: roundedCorners)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(icon: UIImage, title: String, hideSeparator: Bool, roundedCorners: UIRectCorner) {
        iconImageView.image = icon
        titleLabel.text = title
        separatorView.isHidden = true

        bgView.roundCorners(roundedCorners, radius: 10)
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

extension QuickActionComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue as? ABView
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.secondaryBg().value
        separatorView.setBackgorundColor(to: .nonOpaque())

        bgView.setBackgorundColor(to: .tertiaryBg())
        bgView.isHidden = true
        iconImageView.setTintColor(to: .primaryText())

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
    }
}
