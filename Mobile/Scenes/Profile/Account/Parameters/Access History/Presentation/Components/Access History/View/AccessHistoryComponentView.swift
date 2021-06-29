//
//  AccessHistoryComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class AccessHistoryComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: AccessHistoryComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var ipLabel: UILabel!
    @IBOutlet weak private var ipTitleLabel: UILabel!
    @IBOutlet weak private var deviceLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var deviceImageView: UIImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: AccessHistoryComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let ip, let device, let date, let deviceIcon):
                self?.set(ip: ip, device: device, date: date, deviceIcon: deviceIcon)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func set(ip: String, device: String, date: String, deviceIcon: UIImage) {
        ipLabel.text = ip
        deviceLabel.text = device
        dateLabel.text = date
        deviceImageView.image = deviceIcon
    }
}

extension AccessHistoryComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = .clear

        deviceLabel.setFont(to: .body2(fontCase: .lower, fontStyle: .semiBold))
        deviceLabel.setTextColor(to: .primaryText())

        dateLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        dateLabel.setTextColor(to: .secondaryText())

        ipTitleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .semiBold))
        ipTitleLabel.setTextColor(to: .primaryText())

        ipLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        ipLabel.setTextColor(to: .secondaryText())
    }
}
