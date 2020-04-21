//
//  RecentlyPlayedComponentView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class RecentlyPlayedComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: RecentlyPlayedComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var collectionView: UICollectionView!

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: RecentlyPlayedComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let title, let buttonTitle):
                self?.setupUI(title: title, buttonTitle: buttonTitle)
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String, buttonTitle: String) {
        print(#function)
        self.titleLabel.text = title
        self.button.setTitle(buttonTitle, for: .normal)
    }
}

extension RecentlyPlayedComponentView: Xibable {
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

        titleLabel.setTextColor(to: .white)
        titleLabel.setFont(to: .h3)

        button.setBackgorundColor(to: .secondary400)
        button.setTitleColor(to: .neutral100, for: .normal, alpha: 0.6)
        button.setFont(to: .h5)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
}
