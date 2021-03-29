//
//  SuggestedAmountComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/29/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class SuggestedAmountComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: SuggestedAmountComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: SuggestedAmountComponentViewModel) {
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

extension SuggestedAmountComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .systemGrey5())
        
        roundCorners(.allCorners, radius: 20)
        
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .regular))
    }
}
