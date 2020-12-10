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

    override func layoutSubviews() {
        super.layoutSubviews()
        view.roundCorners(.allCorners, radius: 10)
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
        }).disposed(by: diposeBag)

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
        view.backgroundColor = DesignSystem.Color.secondaryBg().value
        ipLabel.setFont(to: .subHeadline(fontCase: .lower))
        ipLabel.setTextColor(to: .primaryText())
        deviceLabel.setFont(to: .caption2(fontCase: .lower))
        deviceLabel.setTextColor(to: .secondaryText())
        dateLabel.setFont(to: .caption2(fontCase: .lower))
        dateLabel.setTextColor(to: .secondaryText())
    }
}
