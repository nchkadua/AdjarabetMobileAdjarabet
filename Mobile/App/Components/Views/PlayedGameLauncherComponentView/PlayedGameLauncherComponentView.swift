//
//  PlayedGameLauncherComponentView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import Nuke

public class PlayedGameLauncherComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: PlayedGameLauncherComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var contentStackView: UIStackView!
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!

    @IBOutlet weak private var loaderView: PlayedGameLauncherComponentLoaderView!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: PlayedGameLauncherComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let coverUrl, let title, let subtitle):
                self?.setupUI(coverUrl: coverUrl, title: title, subtitle: subtitle)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    public func set(isLoading: Bool) {
        contentStackView.isHidden = isLoading
        loaderView.isHidden = !isLoading
    }

    private func setupUI(coverUrl: URL, title: String, subtitle: String?) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.subtitleLabel.isHidden = subtitle == nil

        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        loadImage(with: coverUrl, options: options, into: coverImageView)
    }
}

extension PlayedGameLauncherComponentView: Xibable {
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

        titleLabel.setTextColor(to: .separator())
        titleLabel.setFont(to: .body1)

        subtitleLabel.setTextColor(to: .separator(alpha: 0.6))
        subtitleLabel.setFont(to: .body2)

        set(isLoading: false)
    }
}

public class PlayedGameLauncherComponentLoaderView: UIView {
    @IBOutlet weak public var coverImageView: ShimmerView!
    @IBOutlet weak public var titleLabel: ShimmerView!
    @IBOutlet weak public var subtitleLabel: ShimmerView!

    public var shimmerViews: [ShimmerView] { [coverImageView, titleLabel, subtitleLabel] }
}
