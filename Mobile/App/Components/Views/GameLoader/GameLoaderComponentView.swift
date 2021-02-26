//
//  GameLoaderComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class GameLoaderComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: GameLoaderComponentViewModel!

    @IBOutlet weak private var view: UIView!
    @IBOutlet weak var logoImageView: UIImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    public func setAndBind(viewModel: GameLoaderComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()
        viewModel.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .beginAnimation: self.beginAnimation()
            case .finishAnimation: self.finishAnimation()
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func beginAnimation() {
        isHidden = false

        pulse()
        viewModel.didBeginAnimation()
    }

    private func finishAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.logoImageView.alpha = 0.0
            self.logoImageView.transform = CGAffineTransform(scaleX: 5, y: 5)
        }, completion: {_ in
            self.isHidden = true
        })
    }
}

extension GameLoaderComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        logoImageView.image = R.image.game.logo()
        logoImageView.tintColor = DesignSystem.Color.primaryText().value
        logoImageView.alpha = 0.5

        isHidden = true
    }
}

extension GameLoaderComponentView {
    private func pulse() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.logoImageView.alpha = 1.0
        }, completion: {_ in
            self.viewModel.didFinishAnimation()
        })
    }
}
