//
//  GameLauncherGridComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import Nuke

class GameLauncherGridComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: GameLauncherGridComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var coverImageView: UIImageView!

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
        roundCorners(.allCorners, radius: 10)
    }

    public func setAndBind(viewModel: GameLauncherGridComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let coverUrl, let title, let category, let jackpotAmount):
                self?.setupUI(coverUrl: coverUrl, title: title, category: category, jackpotAmount: jackpotAmount)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }
    private func setupUI(coverUrl: URL, title: String, category: String, jackpotAmount: String?) {
        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        coverImageView.contentMode = .scaleAspectFill
        loadImage(with: coverUrl, options: options, into: coverImageView)
    }
}

extension GameLauncherGridComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = UIColor.clear
    }
}
