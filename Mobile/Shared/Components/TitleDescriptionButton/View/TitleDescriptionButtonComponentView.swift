//
//  TitleDescriptionButtonComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class TitleDescriptionButtonComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: TitleDescriptionButtonComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: TitleDescriptionButtonComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setTitle(let title): self?.titleLabel.text = title
            case .setDescription(let description): self?.descriptionLabel.text = description
            case .setButtonName(let name): self?.button.titleLabel?.text = name
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
}

extension TitleDescriptionButtonComponentView: Xibable {
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
