//
//  GameLauncherComponentView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import Nuke

public class GameLauncherComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: GameLauncherComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var contentStackView: UIStackView!
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var jackpotButton: AppCircularButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet private var titleLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var inImageView: UIImageView!
    @IBOutlet weak private var separatorView: UIView!

    @IBOutlet weak private var loaderView: GameLauncherComponentLoaderView!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: GameLauncherComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let coverUrl, let title, let category, let jackpotAmount):
                self?.setupUI(coverUrl: coverUrl, title: title, category: category, jackpotAmount: jackpotAmount)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    public func set(isLoading: Bool) {
        contentStackView.isHidden = isLoading
        loaderView.isHidden = !isLoading
    }

    private func setupUI(coverUrl: URL, title: String, category: String, jackpotAmount: String?) {
        self.titleLabel.text = title
        self.titleLabelCenterYConstraint.isActive = jackpotAmount != nil
        self.categoryLabel.text = category
        self.jackpotButton.setTitleWithoutAnimation(jackpotAmount, for: .normal)
        self.jackpotButton.isHidden = jackpotAmount == nil

        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        loadImage(with: coverUrl, options: options, into: coverImageView)
    }
}

extension GameLauncherComponentView: Xibable {
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

        jackpotButton.cornerRadius = 3
        jackpotButton.setBackgorundColor(to: .systemRed150())
        jackpotButton.setTitleColor(to: .systemWhite(), for: .normal)
        jackpotButton.setFont(to: .body2)
        jackpotButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4.5, bottom: 2, right: 4.5)

        titleLabel.setTextColor(to: .systemWhite())
        titleLabel.setFont(to: .h4(fontCase: .lower))

        categoryLabel.setTextColor(to: .systemWhite(alpha: 0.7))
        categoryLabel.setFont(to: .body2)

        inImageView.setTintColor(to: .systemWhite())

        separatorView.setBackgorundColor(to: .baseBg100())

        loaderView.getInImageView().setTintColor(to: .systemWhite())
        set(isLoading: false)
    }
}

public class GameLauncherComponentLoaderView: UIView {
    @IBOutlet weak private var coverImageView: ShimmerView!
    @IBOutlet weak private var titleLabel: ShimmerView!
    @IBOutlet weak private var categoryLabel: ShimmerView!
    @IBOutlet weak private var inImageView: UIImageView!

    public var shimmerViews: [ShimmerView] { [coverImageView, titleLabel, categoryLabel] }

    public func getInImageView() -> UIImageView { inImageView }
}
