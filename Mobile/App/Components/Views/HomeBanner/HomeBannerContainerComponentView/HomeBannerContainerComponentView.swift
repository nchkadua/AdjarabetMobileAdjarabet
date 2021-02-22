//
//  HomeBannerContainerComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class HomeBannerContainerComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: HomeBannerContainerComponentViewModel!
    
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var bannerCollectionView: UICollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }
    
    public func setAndBind(viewModel: HomeBannerContainerComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        // TODO EXTRACT Collection Setup ////////////
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.contentInset.left = 20
        bannerCollectionView.contentInset.right = 20
        bannerCollectionView.isPagingEnabled = true
        pageControl.numberOfPages = viewModel.params.banners.count
        ////////////////////////////////////////////////////////////
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .set(let banners):
                self?.set(banners: banners)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.didBind()
    }
    
    private func set(banners: [AppCellDataProvider]) {
        
    }
}

extension HomeBannerContainerComponentView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        let corrected = offset % viewModel.params.banners.count
        pageControl.currentPage = corrected
    }
}

extension HomeBannerContainerComponentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 999 // "Set 'infinite' limit
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataProvider = viewModel.params.banners[indexPath.row % viewModel.params.banners.count]
        let cell = collectionView.dequeueReusable(dataProvider: dataProvider, for: indexPath)
        cell.dataProvider = dataProvider
        return cell
    }
}

extension HomeBannerContainerComponentView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let banner = viewModel.params.banners[indexPath.row % viewModel.params.banners.count] as? CellHeighProvidering {
            return banner.size(for: collectionView.bounds,
                               safeArea: collectionView.bounds,
                               minimumLineSpacing: 0,
                               minimumInteritemSpacing: 0)
        } else {
            return CGSize.zero
        }
    }
}

extension HomeBannerContainerComponentView: Xibable {
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
        bannerCollectionView.register(types: HomeBannerCollectionViewCell.self)
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.flowLayout?.scrollDirection = .horizontal
        bannerCollectionView.flowLayout?.sectionInset = .zero
        bannerCollectionView.flowLayout?.minimumLineSpacing = 0
        bannerCollectionView.flowLayout?.minimumInteritemSpacing = 0
    }
}
