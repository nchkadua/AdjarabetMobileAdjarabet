//
//  PaymentMethodGridComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PaymentMethodGridComponentViewModel: PaymentMethodGridComponentViewModelInput, PaymentMethodGridComponentViewModelOutput {
}

public struct PaymentMethodGridComponentViewModelParams {
    public var paymentMethods: [PaymentMethodCollectionViewCellDataProvider]
}

public protocol PaymentMethodGridComponentViewModelInput {
    func didBind()
    func didSelect(viewModel: PaymentMethodComponentViewModel, indexPath: IndexPath)
    func reloadCollectionView(with paymentMethods: [PaymentMethodCollectionViewCellDataProvider])
}

public protocol PaymentMethodGridComponentViewModelOutput {
    var action: Observable<PaymentMethodGridComponentViewModelOutputAction> { get }
    var params: PaymentMethodGridComponentViewModelParams { get }
}

public enum PaymentMethodGridComponentViewModelOutputAction {
    case setupCollectionView
    case didSelect(indexPath: IndexPath)
    case didSelectPaymentMethod(PaymentMethodComponentViewModel, IndexPath)
    case reloadCollectionView
}

public class DefaultPaymentMethodGridComponentViewModel: DefaultBaseViewModel {
    public var params: PaymentMethodGridComponentViewModelParams
    private let actionSubject = PublishSubject<PaymentMethodGridComponentViewModelOutputAction>()

    public init(params: PaymentMethodGridComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultPaymentMethodGridComponentViewModel: PaymentMethodGridComponentViewModel {
    public var action: Observable<PaymentMethodGridComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setupCollectionView)
    }

    public func didSelect(viewModel: PaymentMethodComponentViewModel, indexPath: IndexPath) {
        actionSubject.onNext(.didSelectPaymentMethod(viewModel, indexPath))
    }

    public func reloadCollectionView(with paymentMethods: [PaymentMethodCollectionViewCellDataProvider]) {
        params.paymentMethods = paymentMethods
        actionSubject.onNext(.reloadCollectionView)
    }
}
