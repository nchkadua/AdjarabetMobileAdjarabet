//
//  GameLauncherComponentView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class GameLauncherComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: GameLauncherComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var jackpotButton: AppCircularButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var inImageView: UIImageView!
    @IBOutlet weak private var separatorView: UIView!

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
            case .set(let coverUrl, let title, let category):
                self?.setupUI(coverUrl: coverUrl, title: title, category: category)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(coverUrl: URL, title: String, category: String) {
        print(#function)
        self.titleLabel.text = title
        self.categoryLabel.text = category
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
        jackpotButton.setBackgorundColor(to: .secondary400)
        jackpotButton.setTitleColor(to: .white, for: .normal)
        jackpotButton.setFont(to: .body2)
        jackpotButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4.5, bottom: 2, right: 4.5)

        titleLabel.setTextColor(to: .white)
        titleLabel.setFont(to: .h4)

        categoryLabel.setTextColor(to: .neutral100, alpha: 0.6)
        categoryLabel.setFont(to: .body2)

        inImageView.setTintColor(to: .neutral100)

        separatorView.setBackgorundColor(to: .neutral700)
    }
}
