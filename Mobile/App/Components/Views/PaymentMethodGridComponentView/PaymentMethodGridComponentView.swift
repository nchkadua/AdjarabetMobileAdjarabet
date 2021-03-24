//
//  PaymentMethodGridComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class PaymentMethodGridComponentView: UIView {
    private var disposeBag = DisposeBag()
    public var viewModel: PaymentMethodGridComponentViewModel!

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!

    private var selectedDataProvider: PaymentMethodCollectionViewCellDataProvider?

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: PaymentMethodGridComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()

        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .setupCollectionView: self?.setupCollectionView()
            case .reloadCollectionView: self?.reloadAndSelectFirst()
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func reloadAndSelectFirst() {
        guard !viewModel.params.paymentMethods.isEmpty else { return }
        collectionView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in /// 0.1  Needed delay after reloading collectionView
            selectedDataProvider = viewModel.params.paymentMethods[0]
            selectedDataProvider?.select()
        }
    }

    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset.left = 16
        self.collectionView.contentInset.right = 16
        self.collectionView.reloadData()
    }
}

extension PaymentMethodGridComponentView: Xibable {
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

        // CollectionView
        collectionView.register(types: PaymentMethodCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.flowLayout?.scrollDirection = .horizontal
    }
}

extension PaymentMethodGridComponentView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataProvider = viewModel.params.paymentMethods[indexPath.row]
        viewModel.didSelect(viewModel: dataProvider, indexPath: indexPath)
        select(dataProvider)
    }

    private func select(_ dataProvider: PaymentMethodCollectionViewCellDataProvider) {
        if let selectedDP = selectedDataProvider {
            selectedDP.deselect()
        }
        dataProvider.select()
        selectedDataProvider = dataProvider
    }
}

extension PaymentMethodGridComponentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.params.paymentMethods.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataProvider = viewModel.params.paymentMethods[indexPath.row]
        let cell = collectionView.dequeueReusable(dataProvider: dataProvider, for: indexPath)
        cell.dataProvider = dataProvider
        return cell
    }
}

extension PaymentMethodGridComponentView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.params.paymentMethods[indexPath.row].size(for: collectionView.bounds, safeArea: collectionView.bounds, minimumLineSpacing: 0, minimumInteritemSpacing: 0)
    }
}
