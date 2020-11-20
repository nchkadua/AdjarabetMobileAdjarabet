//
//  TransactionDetailComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class TransactionDetailsComponentView: UIView {
    private var diposeBag = DisposeBag()
    private var viewModel: TransactionDetailsComponentViewModel!
    
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }
    
    public func setAndBind(viewModel: TransactionDetailsComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let description):
                self?.set(title: title, description: description)
            }
        }).disposed(by: diposeBag)
        
        viewModel.didBind()
    }
    
    private func set(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

extension TransactionDetailsComponentView: Xibable {
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
        titleLabel.setFont(to: .subHeadline(fontCase: .lower))
        titleLabel.setTextColor(to: .primaryText())
        descriptionLabel.setFont(to: .subHeadline(fontCase: .lower))
        descriptionLabel.setTextColor(to: .primaryText())
    }
}
