//
//  MyCardComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MyCardComponentViewModel: MyCardComponentViewModelInput,
                                                MyCardComponentViewModelOutput {}

public struct MyCardComponentViewModelParams {
    let id: Int64
    let bankIcon: UIImage?
    let bankAlias: String
    let dateAdded: String
    let cardNumber: String
    let issuerIcon: UIImage?
}

public protocol MyCardComponentViewModelInput {
    func didBind()
}

public protocol MyCardComponentViewModelOutput {
    var action: Observable<MyCardComponentViewModelOutputAction> { get }
    var params: MyCardComponentViewModelParams { get }
}

public enum MyCardComponentViewModelOutputAction {
    case set(bankIcon: UIImage?,
             bankAlias: String,
             dateAdded: String,
             cardNumber: String,
             issuerIcon: UIImage?)
    case didDelete(withID: Int64, atIndex: IndexPath)
}

public class DefaultMyCardComponentViewModel {
    public var params: MyCardComponentViewModelParams
    private let actionSubject = PublishSubject<MyCardComponentViewModelOutputAction>()
    public init(params: MyCardComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultMyCardComponentViewModel: MyCardComponentViewModel {
    public var action: Observable<MyCardComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(bankIcon: params.bankIcon,
                                  bankAlias: params.bankAlias,
                                  dateAdded: params.dateAdded,
                                  cardNumber: params.cardNumber,
                                  issuerIcon: params.issuerIcon))
    }

    public func didSelect(at indexPath: IndexPath) {
    }

    public func didDelete(at indexPath: IndexPath) {
        actionSubject.onNext(.didDelete(withID: params.id, atIndex: indexPath))
    }
}
