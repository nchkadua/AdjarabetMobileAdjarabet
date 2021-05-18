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

    var viewModel: ABSliderViewModel = DefaultABSliderViewModel() {
        didSet { viewModelDidSet() }
    }

    private var disposeBag = DisposeBag()

    private func viewModelDidSet() {
        disposeBag = DisposeBag()
        viewModel.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .reload:
                self.reloadReceived()
            default:
                break
            }
        }).disposed(by: disposeBag)
        viewModel.onBind()
    }

    private func reloadReceived() {
        // ...
    }

    func setupUI() {
        //
    }
}
