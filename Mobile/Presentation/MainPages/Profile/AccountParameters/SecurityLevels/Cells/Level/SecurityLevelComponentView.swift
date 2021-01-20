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

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var checkbox: UIImageView!

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
        view.roundCorners(.allCorners, radius: 10)
    }

    public func setAndBind(viewModel: SecurityLevelComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let checked):
                self?.set(title: title, checked: checked)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(title: String, checked: Bool) {
        label.text = title
        isChecked = checked
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
        label.setFont(to: .footnote(fontCase: .lower, fontStyle: .bold))
    }
}
