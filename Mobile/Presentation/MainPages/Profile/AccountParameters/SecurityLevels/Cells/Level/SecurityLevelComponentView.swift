//
//  SecurityLevelComponentView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class SecurityLevelComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: SecurityLevelComponentViewModel!

    private var isChecked = false {
        didSet {
            let checked = R.image.components.abCheckbox.checked()!.withRenderingMode(.alwaysOriginal)
            let unchecked = R.image.components.abCheckbox.unchecked()!.withRenderingMode(.alwaysOriginal)
            checkbox.image = isChecked ? checked : unchecked
        }
    }
    private var rectCorner: UIRectCorner = [] {
        didSet { layoutIfNeeded() }
    }

    // MARK: Outlets
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var checkbox: UIImageView!
    @IBOutlet private weak var separator: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.roundCorners(rectCorner, radius: 10)
    }

    public func setAndBind(viewModel: SecurityLevelComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let model):
                self?.set(model: model)
            }
        }).disposed(by: disposeBag)
        viewModel.didBind()
    }

    private func set(model: SecurityLevelComponentViewModelParams) {
        label.text = model.title
        isChecked  = model.selected
        rectCorner = model.corners.rectCorner
        separator.isHidden = !model.separator
    }
}

extension SecurityLevelComponentView: Xibable {
    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.tertiaryBg().value
        label.setTextColor(to: .primaryText())
        label.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        separator.setBackgorundColor(to: .nonOpaque())
    }
}

fileprivate extension SecurityLevelComponentViewModelParams.RoundCorners {
    var rectCorner: UIRectCorner {
        switch self {
        case .none:   return []
        case .top:    return [.topLeft, .topRight]
        case .bottom: return [.bottomLeft, .bottomRight]
        }
    }
}
