//
//  PromotionCellComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import Nuke

public class PromotionComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: PromotionComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var coverImageView: UIImageView!

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
            case .setUpWithPublicPromo(let promo): self?.setupUI(with: promo)
            case .setUpWithPrivatePromo(let promo): self?.setupUI(with: promo)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(with promo: PublicPromosEntity.PublicPromo) {
        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        loadImage(with: URL(string: promo.image) ?? URL(fileURLWithPath: ""), options: options, into: coverImageView, progress: .none, completion: nil)
    }

    private func setupUI(with promo: PrivatePromosEntity.PrivatePromo) {
        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        loadImage(with: URL(string: promo.image) ?? URL(fileURLWithPath: ""), options: options, into: coverImageView, progress: .none, completion: nil)
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
    }
}
