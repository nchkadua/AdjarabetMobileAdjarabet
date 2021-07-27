//
//  ContactAddressComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class ContactAddressComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: ContactAddressComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!

    @IBOutlet weak var separator: UIView!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: ContactAddressComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setupWith(let address): self?.setup(with: address)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setup(with address: Address) {
        addressLabel.text = address.title
        cityLabel.text = address.city
    }
}

extension ContactAddressComponentView: Xibable {
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
        separator.setBackgorundColor(to: .opaque())

        addressLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        addressLabel.setTextColor(to: .primaryText())

        cityLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
        cityLabel.setTextColor(to: .secondaryText())

        imageView.image = R.image.contact.location()?.withRenderingMode(.alwaysOriginal)
    }
}
