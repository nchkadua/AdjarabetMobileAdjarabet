//
//  PromotionCellComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PromotionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: PromotionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleBgView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: PromotionComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let cover, let icon):
                self?.setupUI(title: title, cover: cover, icon: icon)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String, cover: UIImage, icon: UIImage) {
        titleLabel.text = title
        coverImageView.image = cover
        iconImageView.image = icon
    }

    private func setupViews() {
        coverImageView.roundCorners([.allCorners], radius: 5)
        titleBgView.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        titleBgView.blurred()
        titleBgView.bringSubviewToFront(titleLabel)
    }
}

extension PromotionComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.primaryBg().value

        titleBgView.setBackgorundColor(to: .ultrathin())
        titleBgView.roundCorners([.bottomLeft, .bottomRight], radius: 5)

        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .headline(fontCase: .upper, fontStyle: .bold))
    }
}
