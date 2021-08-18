//
//  EmptyPageComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class EmptyPageComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: EmptyPageComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: EmptyPageComponentViewModel) {
        self.viewModel = viewModel
        
        iconImageView.image = viewModel.params.icon
        titleLabel.text = viewModel.params.title
        descriptionLabel.text = viewModel.params.description
        
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

extension EmptyPageComponentView: Xibable {
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
