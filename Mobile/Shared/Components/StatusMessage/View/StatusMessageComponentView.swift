//
//  StatusMessageComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class StatusMessageComponentView: UIView {
    
    typealias ViewModel = StatusMessageComponentViewModel
    
    private var disposeBag = DisposeBag()
    private var viewModel: ViewModel!

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

    public func setAndBind(viewModel: ViewModel) {
        self.viewModel = viewModel
        configure(with: viewModel)
        bind()
    }
    
    public func configure(with viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.statusLabel.text = viewModel.type.description
            self.view.backgroundColor = viewModel.type.color
            self.configureViewAppearance(with: viewModel)
        }
    }
    
    private func configureViewAppearance(with viewModel: ViewModel) {
        switch viewModel.type {
        case .initial:
            self.hide()
        case .connectionEstablished:
            self.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.hide()
                })
            }
        case .connectionFailed:
            print("*** connectionFailed in View.configure")
            UIView.animate(withDuration: 0.5, animations: {
                self.show()
            })
        }
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .configure(let viewModel):
                self?.configure(with: viewModel)
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
    }
}
