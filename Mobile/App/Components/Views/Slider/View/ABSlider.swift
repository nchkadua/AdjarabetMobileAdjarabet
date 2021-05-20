//
//  ABSlider.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit
import RxSwift

class ABSlider: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    var viewModel: ABSliderViewModel = DefaultABSliderViewModel.default {
        didSet { viewModelDidSet() }
    }

    private var disposeBag = DisposeBag()
    private var timer: Timer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    private func viewModelDidSet() {
        disposeBag = DisposeBag()
        viewModel.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .reload:
                self.reload()
            case .reinitPager:
                self.pageControl.currentPage = 0
            default:
                break
            }
        }).disposed(by: disposeBag)
        viewModel.onBind()
    }

    private func reload() {
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.collectionView.scrollToItem(at: .init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            self.pageControl.numberOfPages = self.viewModel.pageCount()
            self.pageControl.currentPage = 0
        }
    }

    func setupUI() {
        // setup collection view
        collectionView.register(UINib(resource: R.nib.abSliderCell), forCellWithReuseIdentifier: "ABSliderCell")
        // auto-scrolling setup
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        viewModelDidSet() // for initial setting
    }

    @objc func scroll() {
        guard currentCell != nil else { return } // just to checkout if currentCell exists
        let currentPage = pageControl.currentPage
        let nextPage = viewModel.nextPage(currentPage: currentPage)
        pageControl.currentPage = nextPage
        onPageControlChange()
    }

    @IBAction private func pageControlDidChange() {
        onPageControlChange()
    }

    private func onPageControlChange() {
        guard let currentCell = currentCell else { return }
        let rowToScroll = viewModel.rowToScroll(currentPage: pageControl.currentPage,
                                                currentCell: currentCell)
        collectionView.scrollToItem(at: .init(row: rowToScroll, section: 0), at: .centeredHorizontally, animated: true)
    }

    private var currentCell: Int? {
        collectionView.indexPath(for: collectionView.visibleCells[0])?.row
    }
}

extension ABSlider: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ABSliderCell", for: indexPath) as! ABSliderCell
        // swiftlint:enable force_cast
        cell.configure(with: .init(image: viewModel.image(at: indexPath.row)))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        frame.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let page = Int(x / frame.width)
        pageControl.currentPage = viewModel.index(of: page)
    }
}
