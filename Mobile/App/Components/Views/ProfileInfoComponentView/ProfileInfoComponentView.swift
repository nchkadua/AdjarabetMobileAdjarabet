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
    @IBOutlet weak private var verificationStatusImageView: UIImageView!
    @IBOutlet weak private var userIdLabel: UILabel!
    @IBOutlet weak private var copyButton: UIButton!

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
        userIdLabel.text = String(userId)

        verificationStatusLabel.text = R.string.localization.verified()
        verificationStatusImageView.image = R.image.components.profileCell.verified()
    }

    @objc private func copyUserId() {
        UIPasteboard.general.string = userIdLabel.text
        viewModel.didCopyUserId()
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
        view.backgroundColor = .clear

        logoImageView.image = R.image.components.profileCell.adjarabet_logo()

        usernameLabel.setTextColor(to: .systemWhite())
        usernameLabel.setFont(to: .h1(fontCase: .lower))

        verificationStatusLabel.setTextColor(to: DesignSystem.Color.systemWhite(alpha: 0.8))
        verificationStatusLabel.setFont(to: .p)
        verificationStatusImageView.image = R.image.components.profileCell.verified()

        userIdLabel.setTextColor(to: .systemWhite())
        userIdLabel.setFont(to: .h3(fontCase: .lower))

        copyButton.setImage(R.image.components.profileCell.copy(), for: .normal)
        copyButton.addTarget(self, action: #selector(copyUserId), for: .touchUpInside)
    }
}
