//
//  StatusMessageComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class StatusMessageComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: StatusMessageComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: StatusMessageComponentViewModel) {
        self.viewModel = viewModel
        statusLabel.text = viewModel.params.status
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

extension StatusMessageComponentView: Xibable {
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
