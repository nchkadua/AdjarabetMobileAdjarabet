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

    @IBOutlet weak private var loaderView: RecentlyPlayedComponentLoaderView!

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

    public func set(isLoading: Bool) {
        collectionView.isHidden = isLoading
        loaderView.isHidden = !isLoading
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

        titleLabel.setTextColor(to: .separator())
        titleLabel.setFont(to: .h3(fontCase: .lower))

        button.setTitleColor(to: .separator(alpha: 0.6), for: .normal)
        button.setFont(to: .h5(fontCase: .lower))
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.addTarget(self, action: #selector(buttinDidTap), for: .touchUpInside)

        collectionView.register(types: PlayedGameLauncherCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.flowLayout?.scrollDirection = .horizontal
        collectionView.flowLayout?.sectionInset = .zero
        collectionView.flowLayout?.minimumLineSpacing = 10
        collectionView.flowLayout?.minimumInteritemSpacing = 0

        set(isLoading: false)
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
        viewModel.params.playedGames[indexPath.row].size(for: collectionView.bounds,
                                                         safeArea: collectionView.bounds,
                                                         minimumLineSpacing: 0,
                                                         minimumInteritemSpacing: 0)
    }
}

public class RecentlyPlayedComponentLoaderView: UIView {
    private lazy var stackView: UIStackView = {
        let sw = UIStackView()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.distribution = .fill
        sw.alignment = .top
        sw.axis = .horizontal
        sw.spacing = 10
        sw.isLayoutMarginsRelativeArrangement = true
        sw.layoutMargins.left = 20
        return sw
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInitialize()
    }

    private func sharedInitialize() {
        addSubview(stackView)
        stackView.pin(to: self).traling.isActive = false

        (1...10).forEach { _ in
            let v = PlayedGameLauncherComponentView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.set(isLoading: true)
            stackView.addArrangedSubview(v)
            v.heightAnchor.constraint(equalToConstant: 160).isActive = true
            v.widthAnchor.constraint(equalToConstant: 90).isActive = true
        }
    }
}
