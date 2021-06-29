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
    @IBOutlet weak private var separatorView: UIView!

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
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let shouldShowSeparator):
                self?.set(title: title, showSeparator: shouldShowSeparator)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(title: String, showSeparator: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dayDate = dateFormatter.date(from: title) else {
            titleLabel.text = title.uppercased()
            return
        }
        guard !Calendar.current.isDateInToday(dayDate) else {
            titleLabel.text = R.string.localization.component_date_header_today().uppercased()
            return
        }
        dateFormatter.dateFormat = "d MMMM"
        let formattedDateString = dateFormatter.string(from: dayDate)
        titleLabel.text = formattedDateString.uppercased()

        separatorView.isHidden = !showSeparator
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
        view.setBackgorundColor(to: .secondaryBg())
        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())

        separatorView.setBackgorundColor(to: .tertiaryBg())
        separatorView.isHidden = true
    }
}
