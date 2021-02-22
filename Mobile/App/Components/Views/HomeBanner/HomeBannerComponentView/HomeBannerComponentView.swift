//
//  HomeBannerComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class HomeBannerComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: HomeBannerComponentViewModel!
    
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var bannerImageView: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: HomeBannerComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let banner):
                self?.set(banner: banner)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
    
    private func set(banner: UIImage) {
        bannerImageView.image = banner
    }
}

extension HomeBannerComponentView: Xibable {
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
