//
//  HomeBannerContainerComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class HomeBannerContainerComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: HomeBannerContainerComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: HomeBannerContainerComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
}

extension HomeBannerContainerComponentView: Xibable {
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
