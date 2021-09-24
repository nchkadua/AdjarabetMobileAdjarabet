//
//  ContactAddressComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ContactAddressComponentViewModel: ContactAddressComponentViewModelInput,
                                                ContactAddressComponentViewModelOutput {}

public struct ContactAddressComponentViewModelParams {
    let address: ContactAddress
}

public protocol ContactAddressComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol ContactAddressComponentViewModelOutput {
    var action: Observable<ContactAddressComponentViewModelOutputAction> { get }
    var params: ContactAddressComponentViewModelParams { get }
}

public enum ContactAddressComponentViewModelOutputAction {
    case setupWith(address: ContactAddress)
    case didSelect(address: ContactAddress, indexPath: IndexPath)
}

public class DefaultContactAddressComponentViewModel {
    public var params: ContactAddressComponentViewModelParams
    private let actionSubject = PublishSubject<ContactAddressComponentViewModelOutputAction>()
    public init(params: ContactAddressComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultContactAddressComponentViewModel: ContactAddressComponentViewModel {
    public var action: Observable<ContactAddressComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setupWith(address: params.address))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(address: params.address, indexPath: indexPath))
    }
}
