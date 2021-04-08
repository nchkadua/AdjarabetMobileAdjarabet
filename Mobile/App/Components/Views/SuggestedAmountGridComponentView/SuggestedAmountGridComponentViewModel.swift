//
//  SuggestedAmountGridComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/29/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SuggestedAmountGridComponentViewModel: SuggestedAmountGridComponentViewModelInput, SuggestedAmountGridComponentViewModelOutput {
}

public struct SuggestedAmountGridComponentViewModelParams {
    public var suggestedAmouns: [SuggestedAmountCollectionViewCellDataProvider]
}

public protocol SuggestedAmountGridComponentViewModelInput {
    func didBind()
    func didSelect(viewModel: SuggestedAmountComponentViewModel, indexPath: IndexPath)
    func reloadCollectionView(with suggestedAmounts: [SuggestedAmountCollectionViewCellDataProvider])
    func didClickClear()
    func didClickDone()
}

public protocol SuggestedAmountGridComponentViewModelOutput {
    var action: Observable<SuggestedAmountGridComponentViewModelOutputAction> { get }
    var params: SuggestedAmountGridComponentViewModelParams { get }
}

public enum SuggestedAmountGridComponentViewModelOutputAction {
    case setupCollectionView
    case didSelect(indexPath: IndexPath)
    case didSelectSuggestedAmount(SuggestedAmountComponentViewModel, IndexPath)
    case reloadCollectionView
    case didClickClear
    case didClickDone
}

public class DefaultSuggestedAmountGridComponentViewModel: DefaultBaseViewModel {
    public var params: SuggestedAmountGridComponentViewModelParams
    private let actionSubject = PublishSubject<SuggestedAmountGridComponentViewModelOutputAction>()

    public init(params: SuggestedAmountGridComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultSuggestedAmountGridComponentViewModel: SuggestedAmountGridComponentViewModel {
    public var action: Observable<SuggestedAmountGridComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setupCollectionView)
    }

    public func didSelect(viewModel: SuggestedAmountComponentViewModel, indexPath: IndexPath) {
        actionSubject.onNext(.didSelectSuggestedAmount(viewModel, indexPath))
    }

    public func reloadCollectionView(with suggestedAmounts: [SuggestedAmountCollectionViewCellDataProvider]) {
        params.suggestedAmouns = suggestedAmounts
        actionSubject.onNext(.reloadCollectionView)
    }

    public func didClickClear() {
        actionSubject.onNext(.didClickClear)
    }

    public func didClickDone() {
        actionSubject.onNext(.didClickDone)
    }
}
