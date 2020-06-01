//
//  LoadingComponentView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class LoadingComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: LoadingComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet private weak var activitiView: UIActivityIndicatorView!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: LoadingComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setTintColor(let tintColor):
                self?.activitiView.tintColor = tintColor
                self?.activitiView.startAnimating()
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
}

extension LoadingComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
    }
}
