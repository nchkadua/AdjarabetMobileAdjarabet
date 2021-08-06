//
//  AddressHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AddressHeaderComponentViewModel: AddressHeaderComponentViewModelInput,
                                                AddressHeaderComponentViewModelOutput {}

public struct AddressHeaderComponentViewModelParams {
    let title: String
}

public protocol AddressHeaderComponentViewModelInput {
    func didBind()
}

public protocol AddressHeaderComponentViewModelOutput {
    var action: Observable<AddressHeaderComponentViewModelOutputAction> { get }
    var params: AddressHeaderComponentViewModelParams { get }
}

public enum AddressHeaderComponentViewModelOutputAction {
    case set(title: String)
}

public class DefaultAddressHeaderComponentViewModel {
    public var params: AddressHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<AddressHeaderComponentViewModelOutputAction>()
    public init(params: AddressHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultAddressHeaderComponentViewModel: AddressHeaderComponentViewModel {
    public var action: Observable<AddressHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title))
    }
}
