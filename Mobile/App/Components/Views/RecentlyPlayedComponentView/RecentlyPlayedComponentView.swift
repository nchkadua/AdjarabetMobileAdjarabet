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
            case .setupUI:
                self?.setupUI()
            default: break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupUI(title: String, buttonTitle: String) {
        self.titleLabel.text = title
        self.button.setTitleWithoutAnimation(buttonTitle, for: .normal)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset.left = 20
        self.collectionView.contentInset.right = 20
        self.collectionView.reloadData()
    }

    @objc private func buttinDidTap() {
        viewModel.didSelectViewAll()
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

        titleLabel.setTextColor(to: .neutral100)
        titleLabel.setFont(to: .h3)

        button.setTitleColor(to: .neutral100, for: .normal, alpha: 0.6)
        button.setFont(to: .h5)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.addTarget(self, action: #selector(buttinDidTap), for: .touchUpInside)

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(types: PlayedGameLauncherCollectionViewCell.self)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .zero
            flowLayout.minimumLineSpacing = 12
            flowLayout.minimumInteritemSpacing = 0
        }
    }
}

extension RecentlyPlayedComponentView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataProvider = viewModel.params.playedGames[indexPath.row]
        viewModel.didSelect(viewModel: dataProvider, indexPath: indexPath)
    }
}

extension RecentlyPlayedComponentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.params.playedGames.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataProvider = viewModel.params.playedGames[indexPath.row]
        let cell = collectionView.dequeueReusable(dataProvider: dataProvider, for: indexPath)
        cell.dataProvider = dataProvider
        return cell
    }
}

extension RecentlyPlayedComponentView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.params.playedGames[indexPath.row].size(
            for: collectionView.bounds,
            safeArea: collectionView.bounds,
            minimumLineSpacing: 0,
            minimumInteritemSpacing: 0)
    }
}
