//
//  TermsAndConditionsComponentView.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 02.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class TermsAndConditionsComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: TermsAndConditionsComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: TermsAndConditionsComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let number, let title):
                self?.setupUI(number: number, title: title)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(number: Int, title: String) {
        numberLabel.text = "\(number)"
        titleLabel.text = title
    }
}

extension TermsAndConditionsComponentView: Xibable {
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

    override func layoutSubviews() {
        super.layoutSubviews()
        numberView.rounded()
    }
}
