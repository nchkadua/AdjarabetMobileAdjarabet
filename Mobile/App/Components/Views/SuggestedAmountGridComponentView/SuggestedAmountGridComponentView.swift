//
//  SuggestedAmountGridComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/29/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class SuggestedAmountGridComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: SuggestedAmountGridComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!

    private var selectedDataProvider: SuggestedAmountCollectionViewCellDataProvider?

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: SuggestedAmountGridComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setupCollectionView: self?.setupCollectionView()
            case .reloadCollectionView: self?.reload()
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func reload() {
        guard !viewModel.params.suggestedAmouns.isEmpty else { return }
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset.left = 16
        self.collectionView.contentInset.right = 16
        self.collectionView.reloadData()
    }
}

extension SuggestedAmountGridComponentView: Xibable {
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
        collectionView.setBackgorundColor(to: .thick(alpha: 1.0))

        // CollectionView
        collectionView.register(types: SuggestedAmountCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.flowLayout?.scrollDirection = .horizontal
    }
}

extension SuggestedAmountGridComponentView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataProvider = viewModel.params.suggestedAmouns[indexPath.row]
        viewModel.didSelect(viewModel: dataProvider, indexPath: indexPath)
    }
}

extension SuggestedAmountGridComponentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.params.suggestedAmouns.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataProvider = viewModel.params.suggestedAmouns[indexPath.row]
        let cell = collectionView.dequeueReusable(dataProvider: dataProvider, for: indexPath)
        cell.dataProvider = dataProvider
        return cell
    }
}

extension SuggestedAmountGridComponentView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.params.suggestedAmouns[indexPath.row].size(for: collectionView.bounds, safeArea: collectionView.bounds, minimumLineSpacing: 0, minimumInteritemSpacing: 0)
    }
}
