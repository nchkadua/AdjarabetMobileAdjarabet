//
//  DateHeaderComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class DateHeaderComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: DateHeaderComponentViewModel!

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
    public func setAndBind(viewModel: DateHeaderComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title):
                self?.set(title: title)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(title: String) {
        // TODO Extract converting, handle language change
        let relativeFormatter = RelativeDateTimeFormatter()
//        relativeFormatter.locale = Locale(identifier: "ka_GE")
        let dateFormatter = DateFormatter()
        let date = dateFormatter.dayDate(from: title)
        let relativeStringDate = relativeFormatter.localizedString(for: date!, relativeTo: Date())
        titleLabel.text = relativeStringDate
    }
}

extension DateHeaderComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.primaryBg().value
        titleLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .bold))
        titleLabel.setTextColor(to: .primaryText())
    }
}
