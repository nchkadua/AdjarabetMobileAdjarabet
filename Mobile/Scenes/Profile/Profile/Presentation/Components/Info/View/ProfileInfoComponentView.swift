//
//  ProfileInfoComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class ProfileInfoComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: ProfileInfoComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var verificationStatusLabel: UILabel!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: ProfileInfoComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let username, let userId):
                self?.setupUI(username: username, userId: userId)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(username: String, userId: Int) {
        usernameLabel.text = username
        verificationStatusLabel.text = R.string.localization.verified.localized()
        logoImageView.image = R.image.components.profileCell.avatar_verified()
    }
}

extension ProfileInfoComponentView: Xibable {
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

        usernameLabel.setTextColor(to: .primaryText())
        usernameLabel.setFont(to: .largeTitle32(fontCase: .lower, fontStyle: .semiBold))

        verificationStatusLabel.setTextColor(to: .systemBlue())
        verificationStatusLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .regular))
    }
}
